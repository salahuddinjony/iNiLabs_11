import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/contribution_chart.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/homepage_appbar.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/search_bar.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/widgets/repositories.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/user_profile_card.dart';

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

    // Create scroll controller
    final scrollController = ScrollController();

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
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // User Info Header - Scrollable
            UserProfileCard(controller: controller),

            // Contribution Chart - Scrollable
            SliverToBoxAdapter(
              child: Obx(() {
                final user = controller.user;
                if (user == null) return const SizedBox.shrink();

                return ContributionChart(username: user.login);
              }),
            ),

            // Sticky Search bar - Sticks when scrolled to top
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              toolbarHeight: 64,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SearchBarWidget(
                  controller: controller,
                  scrollController: scrollController,
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
