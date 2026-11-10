import 'package:flutter/material.dart';

class AppTheme {
  // YOUR NEW BLUE BRAND COLORS
  static const Color primary = Color(0xFF0D47A1); // Deep Blue
  static const Color accent = Color(0xFF1976D2); // Lighter Blue
  static const Color bg = Color(0xFFFFFFFF); // White Background

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black87, // Dark text for white app bar
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primary,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors
              .grey.shade100, // Light grey input fields on white background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      );
}
