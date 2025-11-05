import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/controller/file_viewer_controller.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/code_viewer_with_line_numbers.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/code_viewer_without_line_numbers.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/file_info_bar.dart';

/// Widget to display file content with info bar and code viewer
class FileContentWidget extends StatelessWidget {
  final FileViewerController fileController;
  final String fileName;
  final VoidCallback onCopyAll;

  const FileContentWidget({
    super.key,
    required this.fileController,
    required this.fileName,
    required this.onCopyAll,
  });

  @override
  Widget build(BuildContext context) {
    final content = fileController.fileContent.value!;
    final decodedContent = fileController.getDecodedContent();
    final lines = fileController.getContentLines();

    return Column(
      children: [
        // File info bar
        FileInfoBar(
          fileName: fileName,
          lineCount: lines.length,
          fileSize: content.size,
          onCopyAll: onCopyAll,
        ),

        // Code content
        Expanded(
          child: Obx(
            () => SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: fileController.showLineNumbers.value
                      ? CodeViewerWithLineNumbers(
                          lines: lines,
                          fileName: fileName,
                        )
                      : CodeViewerWithoutLineNumbers(
                          content: decodedContent,
                          fileName: fileName,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
