import 'package:flutter/material.dart';

/// Palette. Deliberately no red anywhere in child mode.
abstract final class AppColors {
  static const background = Color(0xFFFFF8EE);
  static const surface = Colors.white;
  static const ink = Color(0xFF2D2A4A);
  static const inkSoft = Color(0xFF5E5A7A);
  static const primary = Color(0xFF5B4BC4);
  static const done = Color(0xFF1F7A52);
  static const star = Color(0xFFFFB800);
  static const timer = Color(0xFF4FA3E0);
  static const timerTrack = Color(0xFFE3EEF8);
  static const morning = Color(0xFFFFD98A);
  static const noon = Color(0xFFA8DCF5);
  static const evening = Color(0xFFC9BFF2);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Fredoka',
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, color: AppColors.ink),
      bodyLarge: TextStyle(color: AppColors.ink),
      bodyMedium: TextStyle(color: AppColors.inkSoft),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  );
}
