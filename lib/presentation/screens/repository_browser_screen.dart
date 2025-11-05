import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/presentation/controllers/repository_browser_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Repository Browser Screen - Browse files and folders
class RepositoryBrowserScreen extends StatelessWidget {
  final repo_model.GithubRepository repository;

  const RepositoryBrowserScreen({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RepositoryBrowserController(repository: repository),
      tag: repository.fullName,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress(context, controller);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBackPress(context, controller),
          ),
          title: Obx(() => Text(
            controller.pathStack.isEmpty
                ? 'Browse Files'
                : controller.pathStack.last,
            overflow: TextOverflow.ellipsis,
          )),
          actions: [
            // Download ZIP
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _showDownloadDialog(context, controller),
              tooltip: 'Download ZIP',
            ),
            // Copy clone URL
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () => _copyCloneUrl(context, controller),
              tooltip: 'Copy Clone URL',
            ),
          ],
        ),
        body: Column(
          children: [
            // Breadcrumb
            _buildBreadcrumb(context, controller),
            
            // Content list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value != null) {
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
                          'Failed to load contents',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          controller.error.value!,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.contents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64.sp,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Empty directory',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchContents(controller.currentPath.value),
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppConstants.paddingSmall),
                    itemCount: controller.contents.length,
                    itemBuilder: (context, index) {
                      final item = controller.contents[index];
                      return _buildContentItem(context, controller, item);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle back button press - navigate up in folder hierarchy or exit
  void _handleBackPress(BuildContext context, RepositoryBrowserController controller) {
    if (controller.pathStack.isEmpty) {
      // At root level, exit the screen
      context.pop();
    } else {
      // Navigate up one folder
      controller.navigateBack();
    }
  }

  Widget _buildBreadcrumb(BuildContext context, RepositoryBrowserController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        return Row(
          children: [
            Icon(
              Icons.folder,
              size: 16.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  controller.getBreadcrumb(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildContentItem(
    BuildContext context,
    RepositoryBrowserController controller,
    item,
  ) {
    final isDirectory = item.isDirectory;
    
    return Card(
      margin: EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(
          isDirectory ? Icons.folder : _getFileIcon(item.name),
          color: isDirectory
              ? Colors.amber[700]
              : Theme.of(context).colorScheme.primary,
          size: 28.sp,
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: !isDirectory
            ? Text(
                _formatFileSize(item.size ?? 0),
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: Icon(
          isDirectory ? Icons.chevron_right : Icons.code,
          size: 20.sp,
        ),
        onTap: () {
          if (isDirectory) {
            controller.navigateToDirectory(item.path, item.name);
          } else {
            // Navigate to file viewer
            context.pushNamed(
              RoutePath.fileViewer,
              extra: {
                'controller': controller,
                'filePath': item.path,
                'fileName': item.name,
              },
            );
          }
        },
      ),
    );
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
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'svg':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
      case 'tar':
      case 'gz':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _showDownloadDialog(BuildContext context, RepositoryBrowserController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBranch = (repository.defaultBranch ?? 'main').obs;
    final branches = <String>[].obs;
    final isLoadingBranches = true.obs;

    // Fetch available branches
    controller.fetchBranches().then((fetchedBranches) {
      branches.value = fetchedBranches;
      isLoadingBranches.value = false;
      // Set selected branch if current default is in the list
      if (!branches.contains(selectedBranch.value) && branches.isNotEmpty) {
        selectedBranch.value = branches.first;
      }
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
            width: 1,
          ),
        ),
        title: Row(
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
                Icons.archive,
                color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Download Repository',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder_zip,
                        size: 18.sp,
                        color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Obx(() => Text(
                          '${repository.name}-${selectedBranch.value}.zip',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
                          ),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Divider(
                    color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
                    height: 1,
                  ),
                  SizedBox(height: 8.h),
                  
                  // Branch selector
                  Row(
                    children: [
                      Icon(
                        Icons.source_outlined,
                        size: 14.sp,
                        color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Branch: ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          if (isLoadingBranches.value) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 15.h,
                                width: 15.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
                                ),
                              ),
                            );
                          }
                          
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF21262D) : Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedBranch.value,
                                isDense: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                                ),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
                                ),
                                dropdownColor: isDark ? const Color(0xFF21262D) : Colors.white,
                                items: branches.map((String branch) {
                                  return DropdownMenuItem<String>(
                                    value: branch,
                                    child: Text(branch),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    selectedBranch.value = newValue;
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoRow(
                    context,
                    Icons.person_outline,
                    'Owner',
                    repository.owner.login,
                    isDark,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This will download the repository as a ZIP archive from GitHub.',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        actions: [
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
              side: BorderSide(
                color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
              ),
              backgroundColor: isDark ? const Color(0xFF21262D) : const Color(0xFFF6F8FA),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => ElevatedButton.icon(
            onPressed: isLoadingBranches.value ? null : () {
              context.pop();
              _downloadRepository(controller, selectedBranch.value);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF238636) : const Color(0xFF2DA44E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            icon: Icon(Icons.download, size: 18.sp),
            label: Text(
              'Download ZIP',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
        ),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadRepository(RepositoryBrowserController controller, String branch) async {
    try {
      final url = controller.getDownloadUrl(branch: branch);
      final uri = Uri.parse(url);
      
      // Use external application mode to open the download URL in browser
      // which will trigger the download
      final canLaunch = await canLaunchUrl(uri);
      
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        EasyLoading.showSuccess('Download started...');
      } else {
        // Fallback: try with platformDefault mode
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        EasyLoading.showSuccess('Download started...');
      }
    } catch (e) {
      // If all else fails, show error with helpful message
      EasyLoading.showError('Could not start download. Please try from GitHub website.');
    }
  }

  Future<void> _copyCloneUrl(BuildContext context, RepositoryBrowserController controller) async {
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
                      Icons.content_copy,
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
                          'Clone Repository',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Choose a clone method',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                          ),
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
            
            // Clone options
            _buildCloneOption(
              context,
              'HTTPS',
              controller.getCloneUrl(),
              Icons.lock_outline,
              'Clone using the web URL',
              isDark,
            ),
            
            _buildCloneOption(
              context,
              'SSH',
              controller.getSshUrl(),
              Icons.vpn_key_outlined,
              'Clone using SSH keys',
              isDark,
            ),
            
            _buildCloneOption(
              context,
              'GitHub CLI',
              'gh repo clone ${repository.fullName}',
              Icons.terminal,
              'Clone using GitHub CLI',
              isDark,
            ),
            
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCloneOption(
    BuildContext context,
    String title,
    String url,
    IconData icon,
    String subtitle,
    bool isDark,
  ) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: url));
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
                      '$title URL copied to clipboard',
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
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            url,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'monospace',
                              color: isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.content_copy,
                          size: 14.sp,
                          color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
