import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/widgets/loading_widget.dart';
import 'package:inilab/presentation/widgets/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileCard extends StatelessWidget {
  final HomeController controller; 
  const UserProfileCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return        SliverToBoxAdapter(
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
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        // GitHub Username
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '@${user.login}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.copy,
                                  size: 14,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[500]
                                      : Colors.grey[500],
                                ),
                              ],
                            ),
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
                        
                        // Additional user information
                        _buildAdditionalInfo(context, user),
                        
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
                              onTap: user.followers > 0
                                  ? () {
                                      context.pushNamed(
                                        RoutePath.userList,
                                        extra: {
                                          'username': user.login,
                                          'type': UserListType.followers,
                                        },
                                      );
                                    }
                                  : null,
                            ),
                            buildStatItem(
                              context,
                              'Following',
                              user.following.toString(),
                              onTap: user.following > 0
                                  ? () {
                                      context.pushNamed(
                                        RoutePath.userList,
                                        extra: {
                                          'username': user.login,
                                          'type': UserListType.following,
                                        },
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
  }

  Widget buildStatItem(
    BuildContext context,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    final widget = Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(padding: const EdgeInsets.all(8), child: widget),
      );
    }

    return widget;
  }

  /// Build additional user information section
  Widget _buildAdditionalInfo(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final infoItems = <Widget>[];

    // Email
    if (user.email != null && user.email!.isNotEmpty) {
      infoItems.add(_buildInfoItem(
        context,
        icon: Icons.email_outlined,
        label: user.email!,
        onTap: () => _launchUrl('mailto:${user.email}'),
        isDark: isDark,
      ));
    }

    // Company
    if (user.company != null && user.company!.isNotEmpty) {
      infoItems.add(_buildInfoItem(
        context,
        icon: Icons.business_outlined,
        label: user.company!,
        isDark: isDark,
      ));
    }

    // Location
    if (user.location != null && user.location!.isNotEmpty) {
      infoItems.add(_buildInfoItem(
        context,
        icon: Icons.location_on_outlined,
        label: user.location!,
        isDark: isDark,
      ));
    }

    // Blog/Website
    if (user.blog != null && user.blog!.isNotEmpty) {
      infoItems.add(_buildInfoItem(
        context,
        icon: Icons.link_outlined,
        label: user.blog!,
        onTap: () => _launchUrl(user.blog!.startsWith('http') 
            ? user.blog! 
            : 'https://${user.blog}'),
        isDark: isDark,
      ));
    }

    // Account created date
    if (user.createdAt != null) {
      final createdDate = DateTime.parse(user.createdAt!);
      final monthYear = '${_getMonthName(createdDate.month)} ${createdDate.year}';
      infoItems.add(_buildInfoItem(
        context,
        icon: Icons.calendar_today_outlined,
        label: 'Joined $monthYear',
        isDark: isDark,
      ));
    }

    if (infoItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: infoItems,
    );
  }

  /// Build individual info item
  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    final textColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final iconColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: onTap != null 
                    ? (isDark ? Colors.blue[300] : Colors.blue[700])
                    : textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onTap != null)
            Icon(Icons.open_in_new, size: 14, color: iconColor),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: child,
      );
    }

    return child;
  }

  /// Launch URL
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Fallback
      try {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  /// Get month name
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

