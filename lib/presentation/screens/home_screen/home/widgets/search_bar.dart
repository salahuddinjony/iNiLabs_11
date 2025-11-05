import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';
/// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  final HomeController controller;
  final ScrollController scrollController;

  const SearchBarWidget({
    required this.controller,
    required this.scrollController,
  });

  void _scrollToSearchBar() {
    // Get the current scroll position
    if (scrollController.hasClients) {
      // Check if we're not already at the top
      if (scrollController.offset < scrollController.position.maxScrollExtent) {
        // Animate to the search bar position (which should be at the top when sticky)
        scrollController.animateTo(
          scrollController.position.maxScrollExtent > 0
              ? scrollController.position.minScrollExtent +
                    1000 // Scroll past profile and chart
              : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Initialize with current search query from controller
    final searchController = TextEditingController(
      text: controller.searchQuery,
    );
    final focusNode = FocusNode();

    // Listen to focus changes
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _scrollToSearchBar();
      }
    });

    // Listen to text changes
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        _scrollToSearchBar();
      }
    });

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent, width: 1),
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search repositories',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    suffixIcon: Obx(() {
                      final query = controller.searchQuery;
                      return query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 18,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              onPressed: () {
                                searchController.clear();
                                controller.searchRepositories('');
                              },
                            )
                          : const SizedBox.shrink();
                    }),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) {
                    controller.searchRepositories(value);
                  },
                ),
              ),
            ),
            
            // Show result count when searching
            Obx(() {
              final searchQuery = controller.searchQuery;
              final totalRepos = controller.repositories.length;

              if (searchQuery.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalRepos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}