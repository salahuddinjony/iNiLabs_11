import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';

class InitializeApp {
  static Future<void> initialize() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize theme controller - it will load saved preference automatically
    Get.put(ThemeController());

    // Load environment variables
    await dotenv.load(fileName: ".env");
  }
}
