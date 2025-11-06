import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/controller/file_viewer_controller.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/file_viewer_error_state.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/file_content_widget.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/widgets/copy_content_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// File Viewer Screen - View file contents with syntax highlighting
class FileViewerScreen extends StatelessWidget {
  final RepositoryBrowserController controller;
  final String filePath;
  final String fileName;

  const FileViewerScreen({
    super.key,
    required this.controller,
    required this.filePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with unique tag based on file path
    final bool isAlreadyRegistered =
        Get.isRegistered<FileViewerController>(tag: filePath);
    
    final fileController = isAlreadyRegistered
        ? Get.find<FileViewerController>(tag: filePath)
        : Get.put(
            FileViewerController(
              repositoryController: controller,
              filePath: filePath,
            ),
            tag: filePath,
          );

    // If controller was already registered and has an error, retry loading
    if (isAlreadyRegistered && fileController.error.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fileController.loadFile();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(fileName, overflow: TextOverflow.ellipsis),
        actions: [
          // Toggle line numbers
          Obx(
            () => IconButton(
              icon: Icon(
                fileController.showLineNumbers.value
                    ? Icons.format_list_numbered
                    : Icons.format_align_left,
              ),
              onPressed: fileController.toggleLineNumbers,
              tooltip: fileController.showLineNumbers.value
                  ? 'Hide line numbers'
                  : 'Show line numbers',
            ),
          ),
          // Open on GitHub
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => _openOnGitHub(fileController),
            tooltip: 'Open on GitHub',
          ),
        ],
      ),
      body: Obx(() {
        if (fileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (fileController.error.value != null) {
          return FileViewerErrorState(
            error: fileController.error.value!,
            onRetry: fileController.loadFile,
          );
        }

        if (fileController.fileContent.value == null) {
          return const Center(child: Text('No content available'));
        }

        return FileContentWidget(
          fileController: fileController,
          fileName: fileName,
          onCopyAll: () =>
              CopyContentHelper.showCopyOptions(context, fileController),
        );
      }),
    );
  }

  Future<void> _openOnGitHub(FileViewerController fileController) async {
    if (fileController.fileContent.value?.htmlUrl == null) {
      EasyLoading.showError('GitHub URL not available');
      return;
    }

    try {
      final uri = Uri.parse(fileController.fileContent.value!.htmlUrl!);

      // Try external application mode first
      bool launched = false;

      try {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // If external application fails, try platform default
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (launched) {
        EasyLoading.showSuccess('Opening on GitHub...');
      } else {
        EasyLoading.showError('Could not open GitHub');
      }
    } catch (e) {
      EasyLoading.showError('Failed to open GitHub');
    }
  }
}
