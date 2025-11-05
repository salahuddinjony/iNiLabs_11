import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/clone_url_bottom_sheet.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/download_dialog.dart';

/// AppBar widget for repository browser screen
class RepositoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final repo_model.GithubRepository repository;
  final RepositoryBrowserController controller;

  const RepositoryAppBar({
    super.key,
    required this.repository,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => controller.handleBackPress(context),
      ),
      title: Obx(
        () => Text(
          controller.pathStack.isEmpty ? 'Browse Files' : controller.pathStack.last,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _showDownloadDialog(context),
          tooltip: 'Download ZIP',
        ),
        IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () => _showCloneUrlSheet(context),
          tooltip: 'Copy Clone URL',
        ),
      ],
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DownloadDialog(
        repository: repository,
        controller: controller,
      ),
    );
  }

  void _showCloneUrlSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CloneUrlBottomSheet(
        repository: repository,
        controller: controller,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
