import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom app bar for user list screen with back to profile action
class UserListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const UserListAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.rotate_90_degrees_ccw_rounded),
          onPressed: () {
            // Navigate back to main user's home (pop all the way back)
            while (context.canPop()) {
              context.pop();
            }
          },
          tooltip: 'Go to My Profile',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
