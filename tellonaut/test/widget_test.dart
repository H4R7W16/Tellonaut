// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tellonaut/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('TellonautApp lädt und zeigt Begrüßung', (
    WidgetTester tester,
  ) async {
    // App instanziieren
    await tester.pumpWidget(const TellonautApp());

    // Erwartung: Text "Welcome to Tellonaut!" ist einmal im Widget‑Baum
    expect(find.text('Welcome to Tellonaut!'), findsOneWidget);
  });
}
