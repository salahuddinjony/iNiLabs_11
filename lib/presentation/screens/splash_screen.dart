import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 2500), () async {
      final prefs = await SharedPreferences.getInstance();

      if (!context.mounted) return;

      final userName = prefs.getString('username');
      if (userName != null && userName.isNotEmpty) {
        if (context.mounted) {
          context.goNamed(RoutePath.main);
        }
        return;
      }
      if (context.mounted) {
        context.goNamed(RoutePath.login);
      }
    });

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
              // Logo with simple fade animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Image.asset(
                        'assets/logo/repo_finder_logo.png',
                        width: 280.w,
                        height: 280.w,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image not found
                          return Container(
                            width: 200.w,
                            height: 200.w,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF161B22)
                                  : const Color(
                                      0xFFFFFFFF,
                                    ), // GitHub container bg
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode
                                    ? const Color(0xFF30363D)
                                    : const Color(0xFFD0D7DE), // GitHub border
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.code,
                              size: 100.sp,
                              color: const Color(0xFF58A6FF), // GitHub blue
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 40.h),

              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Text(
                      'REPO FINDER',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? const Color(0xFFC9D1D9)
                            : const Color(0xFF24292F), // GitHub text color
                        letterSpacing: 3,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
