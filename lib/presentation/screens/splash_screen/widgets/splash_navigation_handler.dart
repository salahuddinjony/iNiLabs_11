import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles navigation logic after splash screen delay
class SplashNavigationHandler {
  static Future<void> navigateAfterDelay(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!context.mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('username');

    if (!context.mounted) return;

    if (userName != null && userName.isNotEmpty) {
      context.goNamed(RoutePath.main);
    } else {
      context.goNamed(RoutePath.login);
    }
  }
}
