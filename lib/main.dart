import 'package:flutter/material.dart';
import 'constants.dart';
import 'login_screen.dart'; 
import 'debug_menu_screen.dart';
// TAMBAHKAN IMPORT INI:
import 'main_screen.dart'; 

void main() {
  runApp(const TheKomarsApp());
}

class TheKomarsApp extends StatelessWidget {
  const TheKomarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Komars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          brightness: Brightness.light,
        ),
        textTheme: AppStyles.textTheme,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIconColor: Colors.grey[600],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.primaryButtonStyle,
        ),
      ),
      // UBAH BAGIAN INI:
      // Arahkan ke MainScreen agar Navigasi Bawah langsung muncul
      home: const MainScreen(), 
    );
  }
}