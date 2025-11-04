import 'package:flutter/material.dart';

/// App theme configuration with GitHub vibes
class AppTheme {
  // GitHub Light Theme Colors
  static const Color _lightPrimary = Color(0xFF0969DA); // GitHub blue
  static const Color _lightSecondary = Color(0xFF1F883D); // GitHub green
  static const Color _lightTertiary = Color(0xFF8250DF); // GitHub purple
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightSurface = Color(0xFFF6F8FA); // GitHub canvas subtle
  static const Color _lightBorder = Color(0xFFD0D7DE);
  static const Color _lightText = Color(0xFF1F2328);
  static const Color _lightTextSecondary = Color(0xFF656D76);
  static const Color _lightError = Color(0xFFCF222E);
  
  // GitHub Dark Theme Colors
  static const Color _darkPrimary = Color(0xFF58A6FF); // GitHub dark blue
  static const Color _darkSecondary = Color(0xFF3FB950); // GitHub dark green
  static const Color _darkTertiary = Color(0xFFBC8CFF); // GitHub dark purple
  static const Color _darkBackground = Color(0xFF0D1117); // GitHub dark canvas default
  static const Color _darkSurface = Color(0xFF161B22); // GitHub dark canvas subtle
  static const Color _darkBorder = Color(0xFF30363D);
  static const Color _darkText = Color(0xFFE6EDF3);
  static const Color _darkTextSecondary = Color(0xFF7D8590);
  static const Color _darkError = Color(0xFFFF7B72);
  
  /// Light Theme - GitHub Light Mode
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        surface: _lightSurface,
        error: _lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _lightText,
        outline: _lightBorder,
      ),
      scaffoldBackgroundColor: _lightBackground,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _lightBackground,
        foregroundColor: _lightText,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: _lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: _lightBorder, width: 1),
        ),
        color: _lightBackground,
        surfaceTintColor: Colors.transparent,
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightError, width: 2),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: _lightSecondary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: _lightText, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: _lightText, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: _lightText, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _lightText, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _lightText, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: _lightText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _lightText),
        bodyMedium: TextStyle(color: _lightText),
        bodySmall: TextStyle(color: _lightTextSecondary),
      ),
      
      iconTheme: const IconThemeData(
        color: _lightTextSecondary,
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: _lightPrimary.withValues(alpha: 0.1),
        labelStyle: const TextStyle(color: _lightPrimary, fontWeight: FontWeight.w500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      dividerColor: _lightBorder,
    );
  }
  
  /// Dark Theme - GitHub Dark Mode
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _darkTertiary,
        surface: _darkSurface,
        error: _darkError,
        onPrimary: _darkBackground,
        onSecondary: _darkBackground,
        onSurface: _darkText,
        outline: _darkBorder,
      ),
      scaffoldBackgroundColor: _darkBackground,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _darkBackground,
        foregroundColor: _darkText,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: _darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
        color: _darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkError, width: 2),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: _darkSecondary,
          foregroundColor: _darkBackground,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: _darkText, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: _darkText, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: _darkText, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: _darkText, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _darkText, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: _darkText, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _darkText),
        bodyMedium: TextStyle(color: _darkText),
        bodySmall: TextStyle(color: _darkTextSecondary),
      ),
      
      iconTheme: const IconThemeData(
        color: _darkTextSecondary,
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: _darkPrimary.withValues(alpha: 0.15),
        labelStyle: const TextStyle(color: _darkPrimary, fontWeight: FontWeight.w500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      dividerColor: _darkBorder,
    );
  }
}
