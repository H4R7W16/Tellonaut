import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Android-Backend

import '../../application/block/blockly_controller.dart';

class ProgrammingScreen extends ConsumerStatefulWidget {
  const ProgrammingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends ConsumerState<ProgrammingScreen> {
  late final WebViewController _ctrl;

  @override
  void initState() {
    super.initState();

    // ► Controller im neuen 4.x-Stil aufsetzen
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

    // ► Android-Extras, z.B. Dev-Tools
    if (Platform.isAndroid) {
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
            // 👉 NEU: RUN
            tooltip: 'Run & senden',
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () async {
              // 1) Python-String von der WebView holen
              await _ctrl.runJavaScript('sendPython()');
              // -> landet automatisch im Riverpod-State (siehe Channel)
              // 2) nach kurzem Delay UDP schicken
              final py = ref.read(blocklyProvider).python;
              if (py.trim().isNotEmpty) await _sendToTello(py);
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

  /* ---------- Mini-Sender ---------- */
  Future<void> _sendToTello(String python) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    // Tello erst in SDK-Mode
    socket.send(utf8.encode('command'), InternetAddress('192.168.10.1'), 8889);
    await Future.delayed(const Duration(milliseconds: 50));

    for (final line in LineSplitter.split(python)) {
      final cmd = _parse(line);
      if (cmd == null) continue;
      socket.send(utf8.encode(cmd), InternetAddress('192.168.10.1'), 8889);
      await Future.delayed(const Duration(milliseconds: 100));
    }
    socket.close();
  }

  /// "tello.forward(100)"  ->  "forward 100"
  String? _parse(String line) {
    final m = RegExp(r'tello\.(\w+)\((\d*)\)').firstMatch(line.trim());
    if (m == null) return null;
    final name = m.group(1)!;
    final arg = m.group(2)!;
    return [name, arg].where((s) => s.isNotEmpty).join(' ');
  }
}
