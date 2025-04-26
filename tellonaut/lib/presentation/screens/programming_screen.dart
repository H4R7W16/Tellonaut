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
  ConsumerState<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends ConsumerState<ProgrammingScreen> {
  /// Key ohne generischen Typ – sonst bräuchten wir den privaten
  /// `_BlocklyEditorWidgetState`, der außerhalb des Pakets nicht sichtbar ist.
  final GlobalKey _editorKey = GlobalKey();

  late final Future<BlocklyOptions> _workspaceFuture;

  @override
  void initState() {
    super.initState();
    _workspaceFuture = _loadWorkspaceConfig();
  }

  Future<BlocklyOptions> _loadWorkspaceConfig() async {
    final toolboxJson = jsonDecode(
      await rootBundle.loadString('assets/blockly/toolbox_tellonaut.json'),
    );

    return BlocklyOptions.fromJson({
      'toolbox': toolboxJson,
      // Python-Generator laden wir erst später ein
    });
  }

  /// Lädt Blockly-Core, deutsche Sprachdatei und eigene Blöcke
  /// in den WebView-Controller ­(einmalig nach erstem Build).
  Future<void> _injectCustomScripts() async {
    final dynamic state = _editorKey.currentState;
    if (state == null) return;

    final ctrl = state.editor.blocklyController; // per Reflection erreichbar
    final scripts = [
      'assets/blockly/blockly_compressed.js',
      'assets/blockly/blocks_compressed.js',
      'assets/blockly/msg/de.js',
      'assets/blockly/custom_blocks.js',
    ];

    for (final path in scripts) {
      final js = await rootBundle.loadString(path);
      await ctrl.runJavascript(js);
    }
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
            tooltip: 'Generierten Python-Code anzeigen',
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Python-Code'),
                      content: SingleChildScrollView(
                        child: SelectableText(
                          blockState.python.isEmpty
                              ? '— noch kein Code —'
                              : blockState.python,
                        ),
                      ),
                    ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<BlocklyOptions>(
        future: _workspaceFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Toolbox konnte nicht geladen werden:\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Custom-Scripts erst nach dem **ersten** Frame injizieren
          // (sonst ist der WebView-Controller noch null).
          scheduleMicrotask(_injectCustomScripts);

          return BlocklyEditorWidget(
            key: _editorKey,
            workspaceConfiguration: snap.data!,
            // Bloc-State aktualisieren, sobald sich der Workspace ändert
            onChange: (data) {
              ref
                  .read(blocklyProvider.notifier)
                  .update(xml: data.xml, python: data.python ?? '');
            },
          );
        },
      ),
    );
  }
}
