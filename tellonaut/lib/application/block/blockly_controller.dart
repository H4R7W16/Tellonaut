import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlocklyState {
  const BlocklyState({required this.xml, required this.python});
  final String xml; // gesamte Workspace‑XML
  final String python; // generierter Python‑Code
}

class BlocklyController extends StateNotifier<BlocklyState> {
  BlocklyController()
    : super(const BlocklyState(xml: '<xml></xml>', python: ''));

  void update({required String xml, required String python}) {
    state = BlocklyState(xml: xml, python: python);
  }
}

final blocklyProvider = StateNotifierProvider<BlocklyController, BlocklyState>(
  (_) => BlocklyController(),
);
