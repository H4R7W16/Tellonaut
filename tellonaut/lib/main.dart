import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theming/app_theme.dart';
import 'presentation/screens/home_screen.dart';

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
      home: const HomeScreen(),
    );
  }
}
