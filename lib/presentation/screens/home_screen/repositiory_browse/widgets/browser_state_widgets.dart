import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';

/// Empty state widget for repository browser
class EmptyDirectoryWidget extends StatelessWidget {
  const EmptyDirectoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Error state widget for repository browser
class ErrorStateWidget extends StatelessWidget {
  final String error;

  const ErrorStateWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Content list widget for repository browser
class ContentListWidget extends StatelessWidget {
  final RxList contents;
  final RepositoryBrowserController controller;
  final Widget Function(dynamic item) itemBuilder;

  const ContentListWidget({
    super.key,
    required this.contents,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchContents(controller.currentPath.value),
      child: ListView.builder(
        padding: EdgeInsets.all(8.w),
        itemCount: contents.length,
        itemBuilder: (context, index) => itemBuilder(contents[index]),
      ),
    );
  }
}
