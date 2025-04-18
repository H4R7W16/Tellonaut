import 'package:flutter/material.dart';

void main() {
  runApp(const TellonautApp());
}

class TellonautApp extends StatelessWidget {
  const TellonautApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tellonaut',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('Hello Tellonaut'))),
    );
  }
}
