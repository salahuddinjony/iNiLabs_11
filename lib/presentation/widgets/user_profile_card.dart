import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/widgets/loading_widget.dart';
import 'package:inilab/presentation/widgets/user_avatar.dart';
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
}
