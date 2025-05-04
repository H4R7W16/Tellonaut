import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../application/block/blockly_controller.dart';

class ProgrammingScreen extends ConsumerStatefulWidget {
  const ProgrammingScreen({super.key});

  @override
  ConsumerState<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends ConsumerState<ProgrammingScreen> {
  late final WebViewController _ctrl;

  @override
  void initState() {
    super.initState();

    final creationParams =
        Platform.isAndroid
            ? AndroidWebViewControllerCreationParams()
            : PlatformWebViewControllerCreationParams();
    _ctrl =
        WebViewController.fromPlatformCreationParams(creationParams)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'TellonautChannel',
            onMessageReceived:
                (msg) => ref
                    .read(blocklyProvider.notifier)
                    .update(python: msg.message),
          )
          ..loadFlutterAsset('assets/blockly/editor.html');

    if (_ctrl.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = ref.watch(blocklyProvider).python;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockly'),
        actions: [
          IconButton(
            tooltip: 'Run & senden',
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () async {
              // 1) Sichtbares Feedback in der App
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('▶️ Run-Button gedrückt')),
              );
              // 2) Log in der Debug-Console
              debugPrint('▶️ Run-Button gedrückt');

              // 3) JS-Code in der WebView auslösen
              try {
                await _ctrl.runJavaScript('sendPython()');
              } catch (e) {
                debugPrint('❌ Fehler runJavaScript: $e');
              }

              // 4) Python-Code aus dem Riverpod-State lesen
              final py = ref.read(blocklyProvider).python;
              debugPrint('📝 Generierter Python-Code:\n$py');

              // 5) Wenn Code da ist, senden
              if (py.trim().isNotEmpty) {
                await _sendToTello(py);
                debugPrint('✅ Senden abgeschlossen');
              } else {
                debugPrint('⚠️ Kein Python-Code, nichts gesendet');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('SDK-Skript'),
                        content: SelectableText(code),
                      ),
                ),
          ),
        ],
      ),
      body: WebViewWidget(controller: _ctrl),
    );
  }

  Future<void> _sendToTello(String python) async {
    debugPrint('⚙️ _sendToTello gestartet…');
    final telloAddr = InternetAddress('192.168.10.1');
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = socket.receive();
        if (dg != null) {
          final resp = utf8.decode(dg.data);
          debugPrint('📡 Tello antwortet: $resp');
        }
      }
    });

    // SDK-Mode einschalten
    debugPrint('→ Sende: command');
    socket.send(utf8.encode('command'), telloAddr, 8889);
    await Future.delayed(const Duration(milliseconds: 500));

    // jede Zeile aus dem Python-String senden
    for (final line in LineSplitter.split(python)) {
      final cmd = _parse(line);
      if (cmd == null) continue;
      debugPrint('→ Sende: $cmd');
      socket.send(utf8.encode(cmd), telloAddr, 8889);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    await Future.delayed(const Duration(milliseconds: 500));
    socket.close();
    debugPrint('🔒 Socket geschlossen');
  }

  String? _parse(String line) {
    final m = RegExp(r'tello\.(\w+)\((\d*)\)').firstMatch(line.trim());
    if (m == null) return null;
    final name = m.group(1)!;
    final arg = m.group(2)!;
    return [name, arg].where((s) => s.isNotEmpty).join(' ');
  }
}
