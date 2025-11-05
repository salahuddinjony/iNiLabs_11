import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/helper/repository_extensions.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';

/// File/folder item widget for repository browser
class ContentItemWidget extends StatelessWidget {
  final dynamic item;
  final RepositoryBrowserController controller;

  const ContentItemWidget({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDirectory = item.isDirectory;
    final itemName = item.name as String;
    final itemSize = (item.size ?? 0) as int;

    return Card(
      margin: EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(
          isDirectory ? Icons.folder : itemName.fileIcon,
          color: isDirectory
              ? Colors.amber[700]
              : Theme.of(context).colorScheme.primary,
          size: 28.sp,
        ),
        title: Text(
          itemName,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: !isDirectory
            ? Text(
                itemSize.toFileSize(),
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: Icon(
          isDirectory ? Icons.chevron_right : Icons.code,
          size: 20.sp,
        ),
        onTap: () => _handleTap(context, isDirectory),
      ),
    );
  }

  void _handleTap(BuildContext context, bool isDirectory) {
    if (isDirectory) {
      controller.navigateToDirectory(item.path, item.name);
    } else {
      context.pushNamed(
        RoutePath.fileViewer,
        extra: {
          'controller': controller,
          'filePath': item.path,
          'fileName': item.name,
        },
      );
    }
  }
}
