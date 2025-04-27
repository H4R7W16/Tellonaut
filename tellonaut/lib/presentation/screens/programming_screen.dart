import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../application/block/blockly_controller.dart';

class ProgrammingScreen extends ConsumerStatefulWidget {
  const ProgrammingScreen({Key? key}) : super(key: key);

  @override
  _ProgrammingScreenState createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends ConsumerState<ProgrammingScreen> {
  late InAppWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () {
              final py = ref.read(blocklyProvider).python;
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Python-Code'),
                      content: SelectableText(py),
                    ),
              );
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialFile: 'assets/blockly_web/editor.html',
        onWebViewCreated: (c) {
          controller = c;

          controller.addJavaScriptHandler(
            handlerName: 'loadAsset',
            callback: (args) async {
              final path = args.first as String;
              return await rootBundle.loadString(path);
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'evalJS',
            callback: (args) async {
              final path = args.first as String;
              final js = await rootBundle.loadString(path);
              await controller.evaluateJavascript(source: js);
              return null;
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'onChange',
            callback: (args) {
              final python = args.first as String;
              ref.read(blocklyProvider.notifier).updatePython(python);
              return null;
            },
          );
        },
      ),
    );
  }
}
