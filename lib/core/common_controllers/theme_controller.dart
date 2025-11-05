import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:inilab/core/theme/app_theme.dart';

/// Theme Controller for managing app theme
class ThemeController extends GetxController {
  
  
  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() async{
    super.onInit();
   await _loadThemeMode();
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(AppConstants.themeKey);
      
      if (savedTheme != null) {
        _themeMode.value = _getThemeModeFromString(savedTheme);
      } else {
        // Default to system theme if no preference saved
        _themeMode.value = ThemeMode.system;
      }
    } catch (e) {
      // Default to system theme on error
      _themeMode.value = ThemeMode.system;
    }
  }

  /// Toggle between light, dark, and system themes
  Future<void> toggleTheme() async {
    // Cycle through: System -> Light -> Dark -> System
    switch (_themeMode.value) {
      case ThemeMode.system:
        _themeMode.value = ThemeMode.light;
        break;
      case ThemeMode.light:
        _themeMode.value = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode.value = ThemeMode.system;
        break;
    }
    
    await _saveThemeMode();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    debugPrint('Setting theme mode to: $mode');
    _themeMode.value = mode;
    await _saveThemeMode();
  }

  /// Save theme mode to SharedPreferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.themeKey, _themeMode.value.toString());
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  /// Get current theme mode as string for display
  String get currentThemeString {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get icon for current theme mode
  IconData get themeIcon {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Check if currently using dark theme (considering system theme)
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      // Check system brightness to determine dark mode
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  /// Get current theme data
  ThemeData get currentTheme {
    return isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
