import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inilab/core/common_widgets/github_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/helper/repository_extensions.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';

/// Clone URL bottom sheet widget
class CloneUrlBottomSheet extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final RepositoryBrowserController controller;

  const CloneUrlBottomSheet({
    super.key,
    required this.repository,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.githubColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HandleBar(colors: colors),
          _Header(colors: colors),
          Divider(height: 1, color: colors.border),
          _CloneOption(
            title: 'HTTPS',
            url: controller.getCloneUrl(),
            icon: Icons.lock_outline,
            subtitle: 'Clone using the web URL',
            colors: colors,
          ),
          _CloneOption(
            title: 'SSH',
            url: controller.getSshUrl(),
            icon: Icons.vpn_key_outlined,
            subtitle: 'Clone using SSH keys',
            colors: colors,
          ),
          _CloneOption(
            title: 'GitHub CLI',
            url: 'gh repo clone ${repository.fullName}',
            icon: Icons.terminal,
            subtitle: 'Clone using GitHub CLI',
            colors: colors,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _HandleBar extends StatelessWidget {
  final GitHubColors colors;

  const _HandleBar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final GitHubColors colors;

  const _Header({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              Icons.content_copy,
              color: colors.primary,
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
                    color: colors.text,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Choose a clone method',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.textSecondary),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _CloneOption extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;
  final String subtitle;
  final GitHubColors colors;

  const _CloneOption({
    required this.title,
    required this.url,
    required this.icon,
    required this.subtitle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _copyToClipboard(context, title, url),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: colors.textSecondary,
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
                      color: colors.text,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            url,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'monospace',
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.content_copy,
                          size: 14.sp,
                          color: colors.primary,
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

  Future<void> _copyToClipboard(
    BuildContext context,
    String title,
    String url,
  ) async {
    Clipboard.setData(ClipboardData(text: url));
    Navigator.pop(context);
    GitHubSnackBar.show(
      context,
      message: '$title URL copied to clipboard',
    );
  }
}
