import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_widgets/loading_widget.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/controller/user_list_controller.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/widgets/user_list_app_bar.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/widgets/user_list_empty_state.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/widgets/user_list_view.dart';

/// Screen to display followers or following list
class UserListScreen extends StatelessWidget {
  final String username;
  final UserListType type;

  const UserListScreen({super.key, required this.username, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = _getOrCreateController();
    final isFollowers = type == UserListType.followers;

    return Scaffold(
      appBar: UserListAppBar(title: isFollowers ? 'Followers' : 'Following'),
      body: Obx(() {
        // Initial loading state
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(
            child: LoadingWidget(message: 'Loading users...'),
          );
        }

        // Empty state
        if (controller.users.isEmpty) {
          return UserListEmptyState(isFollowers: isFollowers);
        }

        // User list with pagination
        return UserListView(controller: controller);
      }),
    );
  }

  /// Get existing controller or create new one with unique tag
  UserListController _getOrCreateController() {
    final tag = '$username-${type.name}';

    if (Get.isRegistered<UserListController>(tag: tag)) {
      return Get.find<UserListController>(tag: tag);
    }

    return Get.put(
      UserListController(username: username, type: type),
      tag: tag,
    );
  }
}
