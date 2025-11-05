import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/helper/extensions.dart';

/// File information bar showing line count and size
class FileInfoBar extends StatelessWidget {
  final String fileName;
  final int lineCount;
  final int fileSize;
  final VoidCallback onCopyAll;

  const FileInfoBar({
    super.key,
    required this.fileName,
    required this.lineCount,
    required this.fileSize,
    required this.onCopyAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            fileName.fileIcon,
            size: 16.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$lineCount lines • ${fileSize.toFileSize()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // Copy All button
          TextButton.icon(
            onPressed: onCopyAll,
            icon: const Icon(Icons.copy_all, size: 16),
            label: const Text('Copy All'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
