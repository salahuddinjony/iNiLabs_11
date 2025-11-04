import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/enums/user_list_type.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/controllers/user_list_controller.dart';
import 'package:inilab/presentation/widgets/loading_widget.dart';
import 'package:inilab/presentation/widgets/user_avatar.dart';

/// Screen to display followers or following list
class UserListScreen extends StatelessWidget {
  final String username;
  final UserListType type;
  
  const UserListScreen({
    super.key,
    required this.username,
    required this.type,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      UserListController(username: username, type: type),
      tag: '$username-${type.name}',
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(type == UserListType.followers ? 'Followers' : 'Following'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navigate back to main user's home (pop all the way back)
              while (context.canPop()) {
                context.pop();
              }
            },
            tooltip: 'Go to My Profile',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(
            child: LoadingWidget(message: 'Loading users...'),
          );
        }
        
        if (controller.users.isEmpty) {
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
                  type == UserListType.followers 
                      ? 'No followers yet' 
                      : 'Not following anyone',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: controller.users.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom
            if (index == controller.users.length) {
              return const Padding(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            final user = controller.users[index];
            
            return Card(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
              child: ListTile(
                leading: UserAvatar(
                  imageUrl: user.avatarUrl,
                  size: 50,
                ),
                title: Text(
                  user.login,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to user's home screen with navigation flag
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
          },
        );
      }),
    );
  }
}
