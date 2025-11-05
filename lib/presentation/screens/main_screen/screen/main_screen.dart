import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/presentation/screens/main_screen/controller/main_controller.dart';
import 'package:inilab/presentation/screens/home_screen/home/screen/home_screen.dart';
import 'package:inilab/presentation/screens/profile_and_settings/screen/profile_screen.dart';
import 'package:inilab/presentation/screens/users_screen/screen/user_search_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  // Initialize MainController
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while loading username
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Use the current username from MainController
      final currentUsername = controller.currentUsername.value;

      final List<Widget> screens = [
        HomeScreen(
          username: currentUsername.isNotEmpty ? currentUsername : null,
        ),
        UserSearchScreen(),
        ProfileScreen(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_search_outlined),
              selectedIcon: Icon(Icons.person_search),
              label: 'Users',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
