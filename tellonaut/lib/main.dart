import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: TellonautApp()));
}

class TellonautApp extends StatelessWidget {
  const TellonautApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tellonaut',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
