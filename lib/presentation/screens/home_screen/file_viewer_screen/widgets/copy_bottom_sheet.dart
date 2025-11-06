import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inilab/helper/extensions.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/controller/file_viewer_controller.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/bottom_sheet_handle.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/copy_bottom_sheet_header.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/copy_option_tile.dart';

/// Bottom sheet widget for copy options
class CopyBottomSheet extends StatelessWidget {
  final BuildContext parentContext;
  final FileViewerController fileController;
  final String fileName;
  final String decodedContent;
  final List<String> lines;
  final bool isDark;

  const CopyBottomSheet({
    super.key,
    required this.parentContext,
    required this.fileController,
    required this.fileName,
    required this.decodedContent,
    required this.lines,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          BottomSheetHandle(isDark: isDark),

          // Header
          CopyBottomSheetHeader(
            fileName: fileName,
            isDark: isDark,
            onClose: () => Navigator.pop(context),
          ),

          // Divider
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
          ),

          // Copy options
          CopyOptionTile(
            parentContext: parentContext,
            title: 'Copy All Code',
            subtitle:
                '${lines.length} lines • ${fileController.fileContent.value!.size.toFileSize()}',
            icon: Icons.copy_all,
            contentToCopy: decodedContent,
            isDark: isDark,
          ),

          CopyOptionTile(
            parentContext: parentContext,
            title: 'Copy Raw Content',
            subtitle: 'Plain text without formatting',
            icon: Icons.text_snippet_outlined,
            contentToCopy: decodedContent,
            isDark: isDark,
          ),

          CopyOptionTile(
            parentContext: parentContext,
            title: 'Copy File Path',
            subtitle: fileController.filePath,
            icon: Icons.link,
            contentToCopy: fileController.filePath,
            isDark: isDark,
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
