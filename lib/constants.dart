import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide Color Constants
class AppColors {
  // Prevent instantiation
  const AppColors._();

  static const Color primary = Color(0xFFE65100); // Burnt Orange
  static const Color secondary = Color(0xFF212121); // Charcoal
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
}

class AppConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 
  static const String imageUrl = 'http://127.0.0.1:8000/storage/';
}

/// App-wide Style Constants
class AppStyles {
  const AppStyles._();

  /// Returns the default TextTheme using Poppins, tailored for the app's colors.
  /// We apply this to the MaterialApp theme.
  static TextTheme get textTheme {
    return GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.secondary,
      displayColor: AppColors.secondary,
    );
  }

  /// Standard Button Style
  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}