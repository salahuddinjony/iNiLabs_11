import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/data/models/repository_content.dart';
import 'package:inilab/presentation/controllers/repository_browser_controller.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// File Viewer Screen - View file contents with syntax highlighting
class FileViewerScreen extends StatefulWidget {
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
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  final RxBool isLoading = true.obs;
  final Rxn<FileContent> fileContent = Rxn<FileContent>();
  final Rxn<String> error = Rxn<String>();
  final RxBool showLineNumbers = true.obs;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    isLoading.value = true;
    error.value = null;

    try {
      final content = await widget.controller.fetchFileContent(widget.filePath);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.fileName,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Toggle line numbers
          Obx(() => IconButton(
            icon: Icon(
              showLineNumbers.value ? Icons.format_list_numbered : Icons.format_align_left,
            ),
            onPressed: () => showLineNumbers.value = !showLineNumbers.value,
            tooltip: showLineNumbers.value ? 'Hide line numbers' : 'Show line numbers',
          )),
          // Open on GitHub
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openOnGitHub,
            tooltip: 'Open on GitHub',
          ),
        ],
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Failed to load file',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    error.value!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                FilledButton.icon(
                  onPressed: _loadFile,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (fileContent.value == null) {
          return const Center(child: Text('No content available'));
        }

        return _buildFileContent(context);
      }),
    );
  }

  Widget _buildFileContent(BuildContext context) {
    final content = fileContent.value!;
    final decodedContent = widget.controller.decodeContent(content.content);
    final lines = decodedContent.split('\n');

    return Column(
      children: [
        // File info bar
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                _getFileIcon(widget.fileName),
                size: 16.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${lines.length} lines • ${_formatFileSize(content.size)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              // Copy All button in info bar
              TextButton.icon(
                onPressed: _copyAllContent,
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
        ),

        // Code content
        Expanded(
          child: Obx(() => SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: showLineNumbers.value
                    ? _buildCodeWithLineNumbers(context, lines)
                    : _buildCodeWithoutLineNumbers(context, decodedContent),
              ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildCodeWithLineNumbers(BuildContext context, List<String> lines) {
    final themeController = Get.find<ThemeController>();
    final numberWidth = (lines.length.toString().length * 8.0) + 16.0;
    final language = _getLanguageFromFileName(widget.fileName);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line numbers
        Container(
          width: numberWidth,
          padding: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(lines.length, (index) {
              return Container(
                height: 21.0, // Match line height
                alignment: Alignment.centerRight,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.outline,
                    height: 1.5,
                  ),
                ),
              );
            }),
          ),
        ),

        // Code content with syntax highlighting
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: HighlightView(
            lines.join('\n'),
            language: language,
            theme: themeController.isDarkMode ? vs2015Theme : vsTheme,
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeWithoutLineNumbers(BuildContext context, String content) {
    final themeController = Get.find<ThemeController>();
    final language = _getLanguageFromFileName(widget.fileName);

    return HighlightView(
      content,
      language: language,
      theme: themeController.isDarkMode ? vs2015Theme : vsTheme,
      padding: EdgeInsets.zero,
      textStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12.sp,
        height: 1.5,
      ),
    );
  }

  String _getLanguageFromFileName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'dart':
        return 'dart';
      case 'java':
        return 'java';
      case 'kt':
        return 'kotlin';
      case 'swift':
        return 'swift';
      case 'cpp':
      case 'cc':
      case 'cxx':
        return 'cpp';
      case 'c':
        return 'c';
      case 'h':
      case 'hpp':
        return 'cpp';
      case 'py':
        return 'python';
      case 'js':
      case 'jsx':
        return 'javascript';
      case 'ts':
      case 'tsx':
        return 'typescript';
      case 'json':
        return 'json';
      case 'xml':
        return 'xml';
      case 'html':
        return 'html';
      case 'css':
        return 'css';
      case 'scss':
        return 'scss';
      case 'yaml':
      case 'yml':
        return 'yaml';
      case 'md':
        return 'markdown';
      case 'sh':
      case 'bash':
        return 'bash';
      case 'sql':
        return 'sql';
      case 'go':
        return 'go';
      case 'rs':
        return 'rust';
      case 'php':
        return 'php';
      case 'rb':
        return 'ruby';
      case 'cs':
        return 'cs';
      default:
        return 'plaintext';
    }
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'dart':
      case 'java':
      case 'kt':
      case 'swift':
      case 'cpp':
      case 'c':
      case 'h':
        return Icons.code;
      case 'py':
        return Icons.code;
      case 'js':
      case 'ts':
      case 'jsx':
      case 'tsx':
        return Icons.javascript;
      case 'json':
        return Icons.data_object;
      case 'xml':
      case 'html':
        return Icons.web;
      case 'md':
      case 'txt':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _copyAllContent() async {
    if (fileContent.value == null) return;

    final decodedContent = widget.controller.decodeContent(fileContent.value!.content);
    final lines = decodedContent.split('\n');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
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
                            color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.fileName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
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
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
            ),

            // Copy options
            _buildCopyOption(
              context,
              'Copy All Code',
              '${lines.length} lines • ${_formatFileSize(fileContent.value!.size)}',
              Icons.copy_all,
              decodedContent,
              isDark,
            ),

            _buildCopyOption(
              context,
              'Copy Raw Content',
              'Plain text without formatting',
              Icons.text_snippet_outlined,
              decodedContent,
              isDark,
            ),

            _buildCopyOption(
              context,
              'Copy File Path',
              widget.filePath,
              Icons.link,
              widget.filePath,
              isDark,
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String contentToCopy,
    bool isDark,
  ) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: contentToCopy));
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 16.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      '$title copied',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: isDark ? const Color(0xFF238636) : const Color(0xFF2DA44E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              margin: EdgeInsets.all(16.w),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
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
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
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
              ),
            ),
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

  Future<void> _openOnGitHub() async {
    if (fileContent.value?.htmlUrl == null) {
      EasyLoading.showError('GitHub URL not available');
      return;
    }

    try {
      final uri = Uri.parse(fileContent.value!.htmlUrl!);
      
      // Try external application mode first
      bool launched = false;
      
      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        // If external application fails, try platform default
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
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
