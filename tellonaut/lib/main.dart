// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theming/app_theme.dart';
// statt home_screen.dart jetzt:
import 'presentation/screens/mode_selection_screen.dart';
// Für named routes (optional):
import 'presentation/screens/live_control_screen.dart';
import 'presentation/screens/programming_screen.dart';

void main() {
  runApp(const ProviderScope(child: TellonautApp()));
}

class TellonautApp extends StatelessWidget {
  const TellonautApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tellonaut',
      theme: buildAppTheme(),
      // neuer Einstieg
      home: const ModeSelectionScreen(),
      // optional: direkte Routen
      routes: {
        '/live-control': (_) => const LiveControlScreen(),
        '/blockly': (_) => const ProgrammingScreen(),
      },
    );
  }
}
