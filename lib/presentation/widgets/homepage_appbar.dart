import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final themeController = Get.find<ThemeController>();
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
          : IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Clean up all controllers before logout
                Get.delete<HomeController>(tag: username ?? 'main');
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');
                if (context.mounted) {
                  context.goNamed(RoutePath.login);
                }
              },
              tooltip: 'Logout',
            ),
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

        // Theme toggle
        Obx(
          () => IconButton(
            icon: Icon(
              themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeController.toggleTheme(),
          ),
        ),
      ],
    );
  }
}
