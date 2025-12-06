// Update file ini agar tidak menyebabkan error build karena UI berubah
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TheKomarsApp());

    // Verify that Login text is present (Ganti pengecekan dari 'Initialization' ke 'Login')
    expect(find.text('Login'), findsWidgets); // findsWidgets karena bisa ada di tombol dan judul
    expect(find.text('The Komars'), findsOneWidget);
  });
}