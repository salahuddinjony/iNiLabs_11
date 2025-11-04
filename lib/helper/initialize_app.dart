import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InitializeApp {

  static Future<void> initialize() async {
    
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();
    
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Pre-load theme preference
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('app_theme') ?? false;
    
    // Initialize theme controller with the loaded theme
    Get.put(ThemeController(initialTheme: isDark ? ThemeMode.dark : ThemeMode.light));
  }
}