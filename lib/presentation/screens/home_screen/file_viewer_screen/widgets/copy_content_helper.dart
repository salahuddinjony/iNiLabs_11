import 'package:flutter/material.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/controller/file_viewer_controller.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/copy_bottom_sheet.dart';

/// Helper class for copy content functionality
class CopyContentHelper {
  /// Show copy options bottom sheet
  static Future<void> showCopyOptions(
    BuildContext context,
    FileViewerController fileController,
  ) async {
    if (fileController.fileContent.value == null) return;

    final decodedContent = fileController.getDecodedContent();
    final lines = fileController.getContentLines();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fileName = fileController.filePath.split('/').last;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => CopyBottomSheet(
        parentContext: context,
        fileController: fileController,
        fileName: fileName,
        decodedContent: decodedContent,
        lines: lines,
        isDark: isDark,
      ),
    );
  }
}
