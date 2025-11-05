import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inilab/helper/extensions.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/controller/file_viewer_controller.dart';

/// Helper class for opening files on GitHub
class GitHubFileOpener {
  static Future<void> openOnGitHub(FileViewerController fileController) async {
    final htmlUrl = fileController.fileContent.value?.htmlUrl;

    if (htmlUrl == null) {
      EasyLoading.showError('GitHub URL not available');
      return;
    }

    try {
      await htmlUrl.launchExternal();
      EasyLoading.showSuccess('Opening on GitHub...');
    } catch (e) {
      EasyLoading.showError('Failed to open GitHub');
    }
  }
}
