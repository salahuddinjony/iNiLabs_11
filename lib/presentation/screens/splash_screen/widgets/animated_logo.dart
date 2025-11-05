import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Animated logo widget with fade and scale animation
class AnimatedLogo extends StatelessWidget {
  final bool isDarkMode;

  const AnimatedLogo({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF161B22)
                    : const Color(0xFFFFFFFF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF30363D)
                      : const Color(0xFFD0D7DE),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.code,
                size: 100.sp,
                color: const Color(0xFF58A6FF), // GitHub blue
              ),
            ),
          ),
        );
      },
    );
  }
}
