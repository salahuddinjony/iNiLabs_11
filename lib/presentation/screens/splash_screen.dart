import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to login after delay
    Future.delayed(const Duration(milliseconds: 2500), () async{
      final userName= await SharedPreferences.getInstance().then((prefs) => prefs.getString('username'));
      if(userName!=null && userName.isNotEmpty){
        if (context.mounted) {
         context.goNamed(RoutePath.home,extra: userName);
        }
        return;
      }
      if (context.mounted) {
        context.goNamed(RoutePath.login);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // GitHub dark background
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
                            color: const Color(0xFF161B22), // GitHub container bg
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF30363D), // GitHub border
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
            
            // Simple app name with GitHub colors
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
                      color: const Color(0xFFC9D1D9), // GitHub text color
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
  }
}
