import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';
import 'package:inilab/core/common_widgets/error_widget.dart' as custom_error;
import 'package:inilab/core/common_widgets/loading_widget.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/repository_card.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/repository_grid_item.dart';

class Repositories extends StatelessWidget {
  final HomeController controller;
  const Repositories({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRepos) {
        return const SliverFillRemaining(
          child: LoadingWidget(message: 'Loading repositories...'),
        );
      }

      // Only show error if we've tried to load at least once
      if (controller.repositories.isEmpty && controller.hasLoadedOnce) {
        return SliverFillRemaining(
          child: custom_error.ErrorWidget(
            message: controller.searchQuery.isNotEmpty
                ? 'No repositories found matching your search'
                : 'No repositories found',
            onRetry: () => controller.refresh(),
          ),
        );
      }

      // If repositories are empty but haven't loaded yet, show nothing (avoid flash)
      if (controller.repositories.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      if (controller.viewType == ViewType.list) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final repo = controller.repositories[index];
            return RepositoryCard(
              repository: repo,
              onTap: () =>
                  context.pushNamed(RoutePath.repositoryDetails, extra: repo),
            );
          }, childCount: controller.repositories.length),
        );
      } else {
        return SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppConstants.paddingMedium,
              mainAxisSpacing: AppConstants.paddingMedium,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final repo = controller.repositories[index];
              return RepositoryGridItem(
                repository: repo,
                onTap: () =>
                    context.pushNamed(RoutePath.repositoryDetails, extra: repo),
              );
            }, childCount: controller.repositories.length),
          ),
        );
      }
    });
  }
}
