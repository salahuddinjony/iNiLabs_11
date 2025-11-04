import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/widgets/contribution_chart.dart';
import 'package:inilab/presentation/widgets/homepage_appbar.dart';
import 'package:inilab/presentation/widgets/repositories.dart';
import 'package:inilab/presentation/widgets/user_profile_card.dart';

/// Home Screen - Displays user info and repositories
class HomeScreen extends StatelessWidget {
  final String? username;
  final bool isFromNavigation;

  const HomeScreen({super.key, this.username, this.isFromNavigation = false});

  @override
  Widget build(BuildContext context) {
    // Use username-specific tag to ensure each user has their own controller instance
    final controller =
        (Get.isRegistered<HomeController>(tag: username ?? 'main')
        ? Get.find<HomeController>(tag: username ?? 'main')
        : Get.put(HomeController(), tag: username ?? 'main'));

    // Initialize controller with username if provided (only if not already initialized)
    if (username != null && controller.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.initialize(username!);
      });
    }

    return Scaffold(
      // App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: HomepageAppbar(
          username: username,
          isFromNavigation: isFromNavigation,
          controller: controller,
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.refresh(),
        child: CustomScrollView(
          slivers: [
            // User Info Header
            UserProfileCard(controller: controller),

            // Contribution Chart
            SliverToBoxAdapter(
              child: Obx(() {
                final user = controller.user;
                if (user == null) return const SizedBox.shrink();

                return ContributionChart(username: user.login);
              }),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search repositories',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => controller.searchRepositories(value),
                ),
              ),
            ),

            // Repositories
            Repositories(controller: controller),
          ],
        ),
      ),
    );
  }
}
