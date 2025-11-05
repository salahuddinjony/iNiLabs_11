import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_widgets/loading_widget.dart';
import 'package:inilab/presentation/screens/users_screen/controller/user_search_controller.dart';
import 'package:inilab/presentation/screens/users_screen/widgets/no_users_found_state.dart';
import 'package:inilab/presentation/screens/users_screen/widgets/search_empty_state.dart';
import 'package:inilab/presentation/screens/users_screen/widgets/user_search_bar.dart';
import 'package:inilab/presentation/screens/users_screen/widgets/user_search_results_list.dart';

/// User search screen
class UserSearchScreen extends StatelessWidget {
  UserSearchScreen({super.key});
  final controller = Get.find<UserSearchController>();

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(
      text: controller.searchQuery.value,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Column(
        children: [
          // Search bar
          UserSearchBar(
            searchController: searchController,
            controller: controller,
          ),

          // Search results
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isSearching.value) {
                return const Center(
                  child: LoadingWidget(message: 'Searching users...'),
                );
              }

              // Empty search query
              if (controller.searchQuery.value.isEmpty) {
                return const SearchEmptyState();
              }

              // No results found
              if (controller.searchResults.isEmpty) {
                return const NoUsersFoundState();
              }

              // Display results
              return UserSearchResultsList(users: controller.searchResults);
            }),
          ),
        ],
      ),
    );
  }
}
