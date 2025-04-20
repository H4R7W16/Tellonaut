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
  late Future<BlocklyOptions> _workspaceFuture;

  @override
  void initState() {
    super.initState();
    _workspaceFuture = _loadWorkspaceConfig();
  }

  Future<BlocklyOptions> _loadWorkspaceConfig() async {
    final toolboxJson = jsonDecode(
      await rootBundle.loadString('assets/blockly/toolbox_default.json'),
    );
    return BlocklyOptions.fromJson({
      'toolbox': toolboxJson,
      // optional:
      // 'plugins': ['python']   // aktiviert Python‑Generator explizit
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blocklyProvider);

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
                          child: SelectableText(state.python),
                        ),
                      ),
                ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _workspaceFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocklyEditorWidget(
            workspaceConfiguration: snapshot.data!,
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
