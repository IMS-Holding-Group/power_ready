import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'IBMPlexSansArabic',
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00E676),
        secondary: Color(0xFF03A9F4),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: Color(0xFFFF5252),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
        onBackground: Color(0xFFFFFFFF),
        onError: Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFFFFFFF)),
        displayMedium: TextStyle(color: Color(0xFFFFFFFF)),
        displaySmall: TextStyle(color: Color(0xFFFFFFFF)),
        headlineLarge: TextStyle(color: Color(0xFFFFFFFF)),
        headlineMedium: TextStyle(color: Color(0xFFFFFFFF)),
        headlineSmall: TextStyle(color: Color(0xFFFFFFFF)),
        titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
        titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
        titleSmall: TextStyle(color: Color(0xFFFFFFFF)),
        bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
        bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
        bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
        labelLarge: TextStyle(color: Color(0xFFFFFFFF)),
        labelMedium: TextStyle(color: Color(0xFFFFFFFF)),
        labelSmall: TextStyle(color: Color(0xFFB0B0B0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00E676), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5252)),
        ),
        labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        hintStyle: const TextStyle(color: Color(0xFF6A6A6A)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF00E676),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00E676),
          foregroundColor: const Color(0xFF000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF00E676),
        ),
      ),
    );
  }
}

