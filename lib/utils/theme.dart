import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class NovaTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NovaColors.background,
      primaryColor: NovaColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: NovaColors.primary,
        secondary: NovaColors.secondary,
        surface: NovaColors.surface,
        error: NovaColors.danger,
      ),
      textTheme: GoogleFonts.rajdhaniTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: NovaColors.textPrimary,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          displayMedium: TextStyle(
            color: NovaColors.primary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
          headlineLarge: TextStyle(
            color: NovaColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
          headlineMedium: TextStyle(
            color: NovaColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: NovaColors.textPrimary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: NovaColors.textSecondary,
            fontSize: 14,
          ),
          labelLarge: TextStyle(
            color: NovaColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: NovaColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFFF1E3A5F),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NovaColors.primary,
          foregroundColor: NovaColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NovaColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF1E3A5F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF1E3A5F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NovaColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: NovaColors.textSecondary),
        hintStyle: const TextStyle(color: NovaColors.textSecondary),
      ),
    );
  }
}
