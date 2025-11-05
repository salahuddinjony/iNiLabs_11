import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';
import 'package:inilab/presentation/screens/splash_screen/widgets/animated_logo.dart';
import 'package:inilab/presentation/screens/splash_screen/widgets/animated_title.dart';
import 'package:inilab/presentation/screens/splash_screen/widgets/splash_navigation_handler.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    // Navigate after delay
    SplashNavigationHandler.navigateAfterDelay(context);

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;

      return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF0D1117)
            : const Color(0xFFF6F8FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedLogo(isDarkMode: isDarkMode),

              SizedBox(height: 40.h),

              // Animated Title
              AnimatedTitle(isDarkMode: isDarkMode),
            ],
          ),
        ),
      );
    });
  }
}
