import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/helper/repository_extensions.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Download repository dialog
class DownloadDialog extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final RepositoryBrowserController controller;

  const DownloadDialog({
    super.key,
    required this.repository,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.githubColors;
    final selectedBranch = (repository.defaultBranch ?? 'main').obs;
    final branches = <String>[].obs;
    final isLoadingBranches = true.obs;

    // Fetch available branches
    controller.fetchBranches().then((fetchedBranches) {
      branches.value = fetchedBranches;
      isLoadingBranches.value = false;
      if (!branches.contains(selectedBranch.value) && branches.isNotEmpty) {
        selectedBranch.value = branches.first;
      }
    });

    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: colors.border, width: 1),
      ),
      title: _DialogTitle(colors: colors),
      content: _DialogContent(
        repository: repository,
        selectedBranch: selectedBranch,
        branches: branches,
        isLoadingBranches: isLoadingBranches,
        colors: colors,
      ),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      actions: [
        _CancelButton(colors: colors),
        SizedBox(width: 8.w),
        _DownloadButton(
          controller: controller,
          selectedBranch: selectedBranch,
          isLoadingBranches: isLoadingBranches,
          colors: colors,
        ),
      ],
    );
  }
}

class _DialogTitle extends StatelessWidget {
  final GitHubColors colors;

  const _DialogTitle({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colors.border),
          ),
          child: Icon(
            Icons.archive,
            color: colors.primary,
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
              color: colors.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogContent extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final Rx<String> selectedBranch;
  final RxList<String> branches;
  final RxBool isLoadingBranches;
  final GitHubColors colors;

  const _DialogContent({
    required this.repository,
    required this.selectedBranch,
    required this.branches,
    required this.isLoadingBranches,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ZipFileName(
                repository: repository,
                selectedBranch: selectedBranch,
                colors: colors,
              ),
              SizedBox(height: 8.h),
              Divider(color: colors.border, height: 1),
              SizedBox(height: 8.h),
              _BranchSelector(
                selectedBranch: selectedBranch,
                branches: branches,
                isLoadingBranches: isLoadingBranches,
                colors: colors,
              ),
              SizedBox(height: 6.h),
              _InfoRow(
                icon: Icons.person_outline,
                label: 'Owner',
                value: repository.owner.login,
                colors: colors,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'This will download the repository as a ZIP archive from GitHub.',
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _ZipFileName extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final Rx<String> selectedBranch;
  final GitHubColors colors;

  const _ZipFileName({
    required this.repository,
    required this.selectedBranch,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.folder_zip, size: 18.sp, color: colors.textSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: Obx(
            () => Text(
              '${repository.name}-${selectedBranch.value}.zip',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BranchSelector extends StatelessWidget {
  final Rx<String> selectedBranch;
  final RxList<String> branches;
  final RxBool isLoadingBranches;
  final GitHubColors colors;

  const _BranchSelector({
    required this.selectedBranch,
    required this.branches,
    required this.isLoadingBranches,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.source_outlined, size: 14.sp, color: colors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          'Branch: ',
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
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
                    color: colors.primary,
                  ),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: colors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBranch.value,
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down, color: colors.textSecondary),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.text,
                  ),
                  dropdownColor: colors.cardBackground,
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
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final GitHubColors colors;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: colors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colors.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  final GitHubColors colors;

  const _CancelButton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.pop(),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.text,
        side: BorderSide(color: colors.border),
        backgroundColor: colors.cardBackground,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
      child: Text(
        'Cancel',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final RepositoryBrowserController controller;
  final Rx<String> selectedBranch;
  final RxBool isLoadingBranches;
  final GitHubColors colors;

  const _DownloadButton({
    required this.controller,
    required this.selectedBranch,
    required this.isLoadingBranches,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: isLoadingBranches.value
            ? null
            : () {
                context.pop();
                _downloadRepository(controller, selectedBranch.value);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.success,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        ),
        icon: Icon(Icons.download, size: 18.sp),
        label: Text(
          'Download ZIP',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _downloadRepository(
    RepositoryBrowserController controller,
    String branch,
  ) async {
    try {
      final url = controller.getDownloadUrl(branch: branch);
      final uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        EasyLoading.showSuccess('Download started...');
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        EasyLoading.showSuccess('Download started...');
      }
    } catch (e) {
      EasyLoading.showError(
        'Could not start download. Please try from GitHub website.',
      );
    }
  }
}
