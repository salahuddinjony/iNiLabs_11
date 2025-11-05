import 'package:get/get.dart';
import 'package:inilab/data/models/repository_content.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';

/// Controller for File Viewer Screen
class FileViewerController extends GetxController {
  final RepositoryBrowserController repositoryController;
  final String filePath;

  FileViewerController({
    required this.repositoryController,
    required this.filePath,
  });

  final RxBool isLoading = true.obs;
  final Rxn<FileContent> fileContent = Rxn<FileContent>();
  final Rxn<String> error = Rxn<String>();
  final RxBool showLineNumbers = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFile();
  }

  /// Load file content
  Future<void> loadFile() async {
    isLoading.value = true;
    error.value = null;

    try {
      final content = await repositoryController.fetchFileContent(filePath);
      if (content != null) {
        fileContent.value = content;
      } else {
        error.value = 'Failed to load file';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle line numbers visibility
  void toggleLineNumbers() {
    showLineNumbers.value = !showLineNumbers.value;
  }

  /// Get decoded content
  String getDecodedContent() {
    if (fileContent.value == null) return '';
    return repositoryController.decodeContent(fileContent.value!.content);
  }

  /// Get content lines
  List<String> getContentLines() {
    return getDecodedContent().split('\n');
  }
}
