// lib/presentation/screens/programming_screen.dart
// ⬇ kompletter File-Inhalt zum Kopieren
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
  final _editorKey = GlobalKey<BlocklyEditorState>();

  @override
  void initState() {
    super.initState();
    _workspaceFut = _loadWorkspaceConfig();
  }

  Future<BlocklyOptions> _loadWorkspaceConfig() async {
    final toolboxJson = jsonDecode(
      await rootBundle.loadString('assets/blockly/toolbox_tellonaut.json'),
    );
    return BlocklyOptions.fromJson({
      'toolbox': toolboxJson,
      // erst wenn Python nötig ist: 'plugins': ['python']
    });
  }

  Future<void> _injectCustomBlocks() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final ctrl = state.controller; // <- richtiger Getter

    // **nur** eigene Blöcke + evtl. Übersetzungen nachladen
    await ctrl.runJavascript(
      await rootBundle.loadString('assets/blockly/msg/de.js'),
    );
    await ctrl.runJavascript(
      await rootBundle.loadString('assets/blockly/custom_blocks.js'),
    );
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
                        title: const Text('Python-Code'),
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
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // nach erstem Frame das Custom-JS injizieren
          scheduleMicrotask(_injectCustomBlocks);

          return BlocklyEditorWidget(
            key: _editorKey,
            workspaceConfiguration: snapshot.data!,
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
