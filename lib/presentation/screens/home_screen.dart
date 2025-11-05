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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _SearchBarWidget(
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

/// Search Bar Widget
class _SearchBarWidget extends StatelessWidget {
  final HomeController controller;
  final ScrollController scrollController;

  const _SearchBarWidget({
    required this.controller,
    required this.scrollController,
  });

  void _scrollToSearchBar() {
    // Get the current scroll position
    if (scrollController.hasClients) {
      // Check if we're not already at the top
      if (scrollController.offset < scrollController.position.maxScrollExtent) {
        // Animate to the search bar position (which should be at the top when sticky)
        scrollController.animateTo(
          scrollController.position.maxScrollExtent > 0
              ? scrollController.position.minScrollExtent +
                    1000 // Scroll past profile and chart
              : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Initialize with current search query from controller
    final searchController = TextEditingController(
      text: controller.searchQuery,
    );
    final focusNode = FocusNode();

    // Listen to focus changes
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _scrollToSearchBar();
      }
    });

    // Listen to text changes
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        _scrollToSearchBar();
      }
    });

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent, width: 1),
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search repositories',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    suffixIcon: Obx(() {
                      final query = controller.searchQuery;
                      return query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 18,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              onPressed: () {
                                searchController.clear();
                                controller.searchRepositories('');
                              },
                            )
                          : const SizedBox.shrink();
                    }),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) {
                    controller.searchRepositories(value);
                  },
                ),
              ),
            ),
            // Show result count when searching
            Obx(() {
              final searchQuery = controller.searchQuery;
              final totalRepos = controller.repositories.length;

              if (searchQuery.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalRepos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
