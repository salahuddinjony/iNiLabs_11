import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/breadcrumb_widget.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/browser_state_widgets.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/content_item_widget.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/repository_app_bar.dart';

/// Repository Browser Screen - Browse files and folders
class RepositoryBrowserScreen extends StatelessWidget {
  final repo_model.GithubRepository repository;

  const RepositoryBrowserScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final bool isAlreadyRegistered =
        Get.isRegistered<RepositoryBrowserController>(tag: repository.fullName);
    
    final controller = isAlreadyRegistered
        ? Get.find<RepositoryBrowserController>(tag: repository.fullName)
        : Get.put(
            RepositoryBrowserController(repository: repository),
            tag: repository.fullName,
          );

    // If controller was already registered and has an error, retry loading
    if (isAlreadyRegistered && controller.error.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchContents(controller.currentPath.value);
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.handleBackPress(context);
      },
      child: Scaffold(
        appBar: RepositoryAppBar(
          repository: repository,
          controller: controller,
        ),
        body: Column(
          children: [
            BreadcrumbWidget(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value != null) {
                  return ErrorStateWidget(
                    error: controller.error.value!,
                    onRetry: () => controller.fetchContents(controller.currentPath.value),
                  );
                }

                if (controller.contents.isEmpty) {
                  return const EmptyDirectoryWidget();
                }

                return ContentListWidget(
                  contents: controller.contents,
                  controller: controller,
                  itemBuilder: (item) =>
                      ContentItemWidget(item: item, controller: controller),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
