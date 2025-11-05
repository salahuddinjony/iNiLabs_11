import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/user_avatar.dart';

/// List view of search results
class UserSearchResultsList extends StatelessWidget {
  final List<GithubUser> users;

  const UserSearchResultsList({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserSearchResultCard(user: user);
      },
    );
  }
}

/// Individual user card in search results
class UserSearchResultCard extends StatelessWidget {
  final GithubUser user;

  const UserSearchResultCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: AppConstants.paddingSmall,
      ),
      child: ListTile(
        leading: UserAvatar(imageUrl: user.avatarUrl, size: 50),
        title: Text(
          user.login,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to home screen with the selected user
          context.pushNamed(
            RoutePath.home,
            extra: {
              'username': user.login,
              'isFromNavigation': true,
            },
          );
        },
      ),
    );
  }
}
