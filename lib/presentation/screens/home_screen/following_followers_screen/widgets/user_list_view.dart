import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/controller/user_list_controller.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/widgets/user_list_card.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/widgets/user_list_loading_indicator.dart';

/// List view displaying users with pagination support
class UserListView extends StatelessWidget {
  final UserListController controller;

  const UserListView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = controller.users;
      final hasMore = controller.hasMore.value;
      final isLoading = controller.isLoading.value;

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: users.length + (hasMore && isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == users.length) {
            return const UserListLoadingIndicator();
          }

          final user = users[index];
          return UserListCard(user: user);
        },
      );
    });
  }
}
