import 'dart:io';
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
}
