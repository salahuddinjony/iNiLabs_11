import 'package:flutter/material.dart';

/// Empty state widget for when user has no followers/following
class UserListEmptyState extends StatelessWidget {
  final bool isFollowers;

  const UserListEmptyState({
    super.key,
    required this.isFollowers,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            isFollowers ? 'No followers yet' : 'Not following anyone',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
