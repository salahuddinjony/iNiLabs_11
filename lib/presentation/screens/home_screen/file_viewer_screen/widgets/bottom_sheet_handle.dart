import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Handle bar widget for bottom sheets
class BottomSheetHandle extends StatelessWidget {
  final bool isDark;

  const BottomSheetHandle({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF30363D)
            : const Color(0xFFD0D7DE),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
