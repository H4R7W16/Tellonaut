import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_blockly/flutter_blockly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/block/blockly_controller.dart';

class ProgrammingScreen extends ConsumerStatefulWidget {
  const ProgrammingScreen({super.key});

  @override
  ConsumerState<ProgrammingScreen> createState() => _ProgState();
}

class _ProgState extends ConsumerState<ProgrammingScreen> {
  late final Future<BlocklyOptions> _workspaceFut;
  final GlobalKey _editorKey = GlobalKey(); // <‑  untypisiert

  @override
  void initState() {
    super.initState();
    _workspaceFut = _loadWorkspaceConfig();
  }

  Future<BlocklyOptions> _loadWorkspaceConfig() async {
    final toolboxJson = jsonDecode(
      await rootBundle.loadString('assets/blockly/toolbox_default.json'),
    );

    return BlocklyOptions.fromJson({
      'toolbox': toolboxJson,
      'plugins': const ['python'],
    });
  }

  /// Lädt eigene Blöcke in den Editor (einmalig).
  Future<void> _injectCustomBlocks() async {
    final state = _editorKey.currentState; // dynamisch
    if (state == null) return;
    final js = await rootBundle.loadString('assets/blockly/custom_blocks.js');

    // Die interne State‑Klasse besitzt das Feld `editor`.
    // Wir casten dynamisch, weil der Typ nicht öffentlich ist.
    (state as dynamic).editor.runJS(js);
  }

  @override
  Widget build(BuildContext context) {
    final blockState = ref.watch(blocklyProvider);

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
                        title: const Text('Python‑Code'),
                        content: SingleChildScrollView(
                          child: SelectableText(blockState.python),
                        ),
                      ),
                ),
          ),
        ],
      ),
      body: FutureBuilder<BlocklyOptions>(
        future: _workspaceFut,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Toolbox‑Fehler:\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          // Nach erstem Build JS injizieren
          scheduleMicrotask(_injectCustomBlocks);

          return BlocklyEditorWidget(
            key: _editorKey,
            workspaceConfiguration: snap.data!,
            onChange:
                (data) => ref
                    .read(blocklyProvider.notifier)
                    .update(xml: data.xml, python: data.python ?? ''),
          );
        },
      ),
    );
  }
}
