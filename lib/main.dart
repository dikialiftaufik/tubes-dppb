import 'package:flutter/material.dart';
import 'constants.dart';

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
      
      // Theme Configuration
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
        
        // Typography
        textTheme: AppStyles.textTheme,
        
        // Component Themes
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.secondary),
          titleTextStyle: TextStyle(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.primaryButtonStyle,
        ),
      ),
      
      home: const InitializationScreen(),
    );
  }
}

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Initialization Complete',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to The Komars',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}