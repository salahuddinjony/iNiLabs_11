import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inilab/core/common_widgets/github_snackbar.dart';

/// A tile widget for copy options in the bottom sheet
class CopyOptionTile extends StatelessWidget {
  final BuildContext parentContext;
  final String title;
  final String subtitle;
  final IconData icon;
  final String contentToCopy;
  final bool isDark;
  final VoidCallback? onBeforeCopy;

  const CopyOptionTile({
    super.key,
    required this.parentContext,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.contentToCopy,
    required this.isDark,
    this.onBeforeCopy,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: contentToCopy));
        onBeforeCopy?.call();
        if (context.mounted) {
          Navigator.pop(context);
          GitHubSnackBar.show(parentContext, message: 'Copied to clipboard');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _buildIconContainer(),
            SizedBox(width: 12.w),
            Expanded(child: _buildTextContent()),
            Icon(
              Icons.content_copy,
              size: 16.sp,
              color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
        ),
      ),
      child: Icon(
        icon,
        size: 18.sp,
        color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
