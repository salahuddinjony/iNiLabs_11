import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/theme/app_theme.dart';

/// Theme Controller for managing app theme
class ThemeController extends GetxController {
  // Observable theme mode
  final Rx<ThemeMode> _themeMode;

  ThemeController({ThemeMode? initialTheme})
    : _themeMode = (initialTheme ?? ThemeMode.light).obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    try {
      final isDark = _themeMode.value == ThemeMode.dark;
      _themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.themeKey, !isDark);

      // Update app theme
      Get.changeThemeMode(_themeMode.value);
    } catch (e) {
      EasyLoading.showError('Failed to change theme');
    }
  }

  /// Get current theme data
  ThemeData get currentTheme {
    return isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
