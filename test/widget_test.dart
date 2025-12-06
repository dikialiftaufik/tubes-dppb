// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tubes/main.dart';

void main() {
  testWidgets('Initialization screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Kita menggunakan TheKomarsApp, bukan MyApp.
    await tester.pumpWidget(const TheKomarsApp());

    // Verify that our specific text is present.
    // Default flutter test mencari angka '0' dan '1' (counter),
    // tapi karena kita mengganti UI-nya, kita harus mengubah ekspektasi test-nya juga.
    expect(find.text('Initialization Complete'), findsOneWidget);
    expect(find.text('Welcome to The Komars'), findsOneWidget);
    
    // Verify standard icons exist
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });
}
