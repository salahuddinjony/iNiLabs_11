import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/enums/user_list_type.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:inilab/presentation/widgets/contribution_chart.dart';
import 'package:inilab/presentation/widgets/error_widget.dart' as custom_error;
import 'package:inilab/presentation/widgets/loading_widget.dart';
import 'package:inilab/presentation/widgets/repository_card.dart';
import 'package:inilab/presentation/widgets/repository_grid_item.dart';
import 'package:inilab/presentation/widgets/user_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home Screen - Displays user info and repositories
class HomeScreen extends StatelessWidget {
  final String? username;
  final bool isFromNavigation;
  
  const HomeScreen({
    super.key, 
    this.username,
    this.isFromNavigation = false,
  });
  
  @override
  Widget build(BuildContext context) {
    // Use username-specific tag to ensure each user has their own controller instance
    final controller = Get.put(
      HomeController(),
      tag: username ?? 'main',
    );
    final themeController = Get.find<ThemeController>();
    
    // Initialize controller with username if provided
    if (username != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.initialize(username!);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
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
          Obx(() => IconButton(
            icon: Icon(
              controller.viewType == ViewType.list 
                  ? Icons.grid_view 
                  : Icons.list,
            ),
            onPressed: () => controller.toggleViewType(),
          )),
          
          // Sort menu
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            onSelected: (type) => controller.changeSortType(type),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortType.updated,
                child: Text('Recently Updated'),
              ),
              const PopupMenuItem(
                value: SortType.name,
                child: Text('Name'),
              ),
              const PopupMenuItem(
                value: SortType.date,
                child: Text('Created Date'),
              ),
              const PopupMenuItem(
                value: SortType.stars,
                child: Text('Stars'),
              ),
            ],
          ),
          
          // Theme toggle
          Obx(() => IconButton(
            icon: Icon(
              themeController.isDarkMode 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
            ),
            onPressed: () => themeController.toggleTheme(),
          )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refresh(),
        child: CustomScrollView(
          slivers: [
            // User Info Header
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(AppConstants.paddingLarge),
                    child: LoadingWidget(message: 'Loading user info...'),
                  );
                }
                
                final user = controller.user;
                if (user == null) return const SizedBox.shrink();
                
                return Card(
                  margin: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      children: [
                        UserAvatar(
                          imageUrl: user.avatarUrl,
                          size: AppConstants.avatarSizeLarge,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          user.name ?? user.login,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.bio != null) ...[
                          const SizedBox(height: AppConstants.paddingSmall),
                          Text(
                            user.bio!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: AppConstants.paddingMedium),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatItem(
                              context,
                              'Repos',
                              user.publicRepos.toString(),
                              onTap: null,
                            ),
                            buildStatItem(
                              context,
                              'Followers',
                              user.followers.toString(),
                              onTap: user.followers > 0 ? () {
                                context.pushNamed(
                                  RoutePath.userList,
                                  extra: {
                                    'username': user.login,
                                    'type': UserListType.followers,
                                  },
                                );
                              } : null,
                            ),
                            buildStatItem(
                              context,
                              'Following',
                              user.following.toString(),
                              onTap: user.following > 0 ? () {
                                context.pushNamed(
                                  RoutePath.userList,
                                  extra: {
                                    'username': user.login,
                                    'type': UserListType.following,
                                  },
                                );
                              } : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            
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
            Obx(() {
              if (controller.isLoadingRepos) {
                return const SliverFillRemaining(
                  child: LoadingWidget(message: 'Loading repositories...'),
                );
              }
              
              if (controller.repositories.isEmpty) {
                return SliverFillRemaining(
                  child: custom_error.ErrorWidget(
                    message: controller.searchQuery.isNotEmpty 
                        ? 'No repositories found matching your search'
                        : 'No repositories found',
                    onRetry: () => controller.refresh(),
                  ),
                );
              }
              
              if (controller.viewType == ViewType.list) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final repo = controller.repositories[index];
                      return RepositoryCard(
                        repository: repo,
                        onTap: () => context.pushNamed(RoutePath.repositoryDetails, extra: repo),
                      );
                    },
                    childCount: controller.repositories.length,
                  ),
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
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final repo = controller.repositories[index];
                        return RepositoryGridItem(
                          repository: repo,
                          onTap: () => context.pushNamed(RoutePath.repositoryDetails, extra: repo),
                        );
                      },
                      childCount: controller.repositories.length,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
  
  Widget buildStatItem(BuildContext context, String label, String value, {VoidCallback? onTap}) {
    final widget = Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: widget,
        ),
      );
    }
    
    return widget;
  }
}
