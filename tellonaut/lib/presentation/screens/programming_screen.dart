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
        leadingWidth: 100,
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('← Zurück', style: TextStyle(color: Colors.white)),
        ),
        title: const Text(
          'Drohnen-Programmierung',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextButton(
              onPressed: _onRunPressed,
              child: const Text(
                'Ausführen',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () => _showCodeDialog(context, code),
              child: const Text('Code', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: WebViewWidget(controller: _ctrl),
    );
  }

  Future<void> _onRunPressed() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('▶️ Ausführen gedrückt')));
    debugPrint('▶️ Run-Button gedrückt');

    try {
      await _ctrl.runJavaScript('sendPython()');
    } catch (e) {
      debugPrint('❌ Fehler runJavaScript: $e');
    }

    final python = ref.read(blocklyProvider).python;
    debugPrint('📝 Generierter Python-Code:\n$python');

    if (python.trim().isNotEmpty) {
      await _sendToTello(python);
      debugPrint('✅ Senden abgeschlossen');
    } else {
      debugPrint('⚠️ Kein Python-Code, nichts gesendet');
    }
  }

  void _showCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Generierter Python-Code'),
            content: SelectableText(code.isEmpty ? '(leer)' : code),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
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
          debugPrint('📡 Tello antwortet: ${utf8.decode(dg.data)}');
        }
      }
    });

    debugPrint('→ Sende: command');
    socket.send(utf8.encode('command'), telloAddr, 8889);
    await Future.delayed(const Duration(milliseconds: 500));

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
