import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Zustand für Blockly: speichert Workspace-XML und generierten Python-Code.
class BlocklyState {
  final String xml;
  final String python;

  const BlocklyState({this.xml = '', this.python = ''});

  /// Erstellt einen neuen State mit optional geänderten Feldern.
  BlocklyState copyWith({String? xml, String? python}) {
    return BlocklyState(xml: xml ?? this.xml, python: python ?? this.python);
  }
}

/// StateNotifier, der den BlocklyState verwaltet.
class BlocklyController extends StateNotifier<BlocklyState> {
  BlocklyController() : super(const BlocklyState());

  /// Aktualisiert sowohl XML als auch Python (je nachdem, was übergeben wurde).
  void update({String? xml, String? python}) {
    state = state.copyWith(xml: xml, python: python);
  }

  /// Aktualisiert nur den Python-Code.
  void updatePython(String python) {
    state = state.copyWith(python: python);
  }
}

/// Riverpod-Provider für BlocklyController und BlocklyState.
final blocklyProvider = StateNotifierProvider<BlocklyController, BlocklyState>(
  (ref) => BlocklyController(),
);
