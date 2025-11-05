import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header widget for the copy bottom sheet
class CopyBottomSheetHeader extends StatelessWidget {
  final String fileName;
  final bool isDark;
  final VoidCallback onClose;

  const CopyBottomSheetHeader({
    super.key,
    required this.fileName,
    required this.isDark,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF30363D)
                    : const Color(0xFFD0D7DE),
              ),
            ),
            child: Icon(
              Icons.code,
              color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Copy Code',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFC9D1D9)
                        : const Color(0xFF24292F),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? const Color(0xFF8B949E)
                        : const Color(0xFF57606A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
            ),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
