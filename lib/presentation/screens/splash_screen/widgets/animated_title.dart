import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Animated app title with fade animation
class AnimatedTitle extends StatelessWidget {
  final bool isDarkMode;

  const AnimatedTitle({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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
                  : const Color(0xFF24292F),
              letterSpacing: 3,
            ),
          ),
        );
      },
    );
  }
}
