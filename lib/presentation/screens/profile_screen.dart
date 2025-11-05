import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/main_controller.dart';
import 'package:inilab/presentation/controllers/profile_controller.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:inilab/presentation/widgets/loading_widget.dart';
import 'package:inilab/presentation/widgets/user_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Profile settings screen - Shows logged user only
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Profile & Settings'),
            floating: true,
            snap: true,
          ),

          // Custom Profile Header - Logged User Only
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(AppConstants.paddingLarge),
                  child: LoadingWidget(message: 'Loading profile...'),
                );
              }

              final user = controller.user;
              if (user == null) {
                return _buildFallbackProfile(context, controller.username);
              }

              return Container(
                margin: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      // Avatar with border
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: UserAvatar(imageUrl: user.avatarUrl, size: 80),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),

                      // Name
                      Text(
                        user.name ?? user.login,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      // Username with copy
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: user.login));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Username copied: ${user.login}'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '@${user.login}',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.copy, size: 16),
                            ],
                          ),
                        ),
                      ),

                      // Bio
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          user.bio!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: AppConstants.paddingMedium),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatChip(
                            context,
                            icon: Icons.book_outlined,
                            label: 'Repos',
                            value: user.publicRepos.toString(),
                          ),
                          _buildStatChip(
                            context,
                            icon: Icons.people_outline,
                            label: 'Followers',
                            value: user.followers.toString(),
                          ),
                          _buildStatChip(
                            context,
                            icon: Icons.person_add_outlined,
                            label: 'Following',
                            value: user.following.toString(),
                          ),
                        ],
                      ),

                      // Quick Info
                      if (user.location != null ||
                          user.company != null ||
                          user.email != null) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        const Divider(),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            if (user.email != null && user.email!.isNotEmpty)
                              _buildInfoChip(
                                context,
                                icon: Icons.email_outlined,
                                text: user.email!,
                              ),
                            if (user.location != null)
                              _buildInfoChip(
                                context,
                                icon: Icons.location_on_outlined,
                                text: user.location!,
                              ),
                            if (user.company != null)
                              _buildInfoChip(
                                context,
                                icon: Icons.business_outlined,
                                text: user.company!,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppConstants.paddingMedium),

                // Settings Section
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(height: 1),

                      // Theme Toggle
                      Obx(
                        () => ListTile(
                          leading: Icon(
                            controller.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                          title: const Text('Dark Mode'),
                          trailing: Switch(
                            value: controller.isDarkMode,
                            onChanged: (_) => controller.toggleTheme(),
                          ),
                          onTap: () => controller.toggleTheme(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Developer Info Section
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: Text(
                          'Developer Info',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(height: 1),

                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('App Version'),
                        trailing: const Text('1.0.0'),
                      ),

                      ListTile(
                        leading: const Icon(Icons.code),
                        title: const Text('Developer Portfolio'),
                        trailing: const Icon(Icons.open_in_new, size: 16),
                        onTap: () =>
                            _launchUrl(AppConstants.developerPortfolioUrl),
                      ),

                      ListTile(
                        leading: const Icon(Icons.bug_report_outlined),
                        title: const Text('Report Issue'),
                        trailing: const Icon(Icons.open_in_new, size: 16),
                        onTap: () => _launchUrl(AppConstants.supportUrl),
                      ),

                      ListTile(
                        leading: const Icon(Icons.star_outline),
                        title: const Text('Rate App'),
                        trailing: const Icon(Icons.open_in_new, size: 16),
                        onTap: () => _launchUrl(AppConstants.ratingUrl),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // About Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        const Text(AppConstants.aboutText),
                        const SizedBox(height: AppConstants.paddingMedium),
                         Text(
                          AppConstants.copyrightText,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Show confirmation dialog
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true && context.mounted) {
                        // Clean up specific controllers (not ThemeController)
                        Get.delete<ProfileController>(force: true);
                        Get.delete<MainController>(force: true);

                        // Try to delete all HomeController instances
                        try {
                          Get.deleteAll(force: true);
                        } catch (e) {
                          // Ignore errors
                        }

                        // Re-register ThemeController if needed
                        if (!Get.isRegistered<ThemeController>()) {
                          Get.put(ThemeController());
                        }

                        // Clear saved username
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('username');

                        // Navigate to login
                        if (context.mounted) {
                          context.goNamed(RoutePath.login);
                        }
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingLarge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Build fallback profile card
  static Widget _buildFallbackProfile(BuildContext context, String username) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              username.isNotEmpty ? username : 'User',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            const Text('GitHub User'),
          ],
        ),
      ),
    );
  }

  // Build stat chip
  static Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  // Build info chip
  static Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        // Handle error silently
      }
    }
  }
}
