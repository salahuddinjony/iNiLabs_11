import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/users_screen/controller/user_search_controller.dart';

/// Search bar widget with clear functionality
class UserSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final UserSearchController controller;

  const UserSearchBar({
    super.key,
    required this.searchController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search GitHub users...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() {
            final query = controller.searchQuery.value;
            return query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      controller.clearSearch();
                    },
                  )
                : const SizedBox.shrink();
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          controller.searchUsers(value);
        },
      ),
    );
  }
}
