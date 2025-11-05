import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';

class HomepageAppbar extends StatelessWidget {
  final String? username;
  final bool isFromNavigation;
  final HomeController controller;
  const HomepageAppbar({
    super.key,
    this.username,
    this.isFromNavigation = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Repositories'),
      // Show back button only when viewing another user's profile
      leading: isFromNavigation
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Clean up the controller when going back
                Get.delete<HomeController>(tag: username ?? 'main');
                context.pop();
              },
              tooltip: 'Back',
            )
          : null,
      actions: [
        // View toggle
        Obx(
          () => IconButton(
            icon: Icon(
              controller.viewType == ViewType.list
                  ? Icons.grid_view
                  : Icons.list,
            ),
            onPressed: () => controller.toggleViewType(),
          ),
        ),

        // Sort menu
        PopupMenuButton<SortType>(
          icon: const Icon(Icons.sort),
          onSelected: (type) => controller.changeSortType(type),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: SortType.updated,
              child: Text('Recently Updated'),
            ),
            const PopupMenuItem(value: SortType.name, child: Text('Name')),
            const PopupMenuItem(
              value: SortType.date,
              child: Text('Created Date'),
            ),
            const PopupMenuItem(value: SortType.stars, child: Text('Stars')),
          ],
        ),
      ],
    );
  }
}
