import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/enums/user_list_type.dart';
import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/data/repositories/github_repository.dart';

/// Controller for managing user list (followers/following)
class UserListController extends GetxController {
  final String username;
  final UserListType type;
  final GithubRepository repository = GithubRepository(ApiService());
  
  UserListController({required this.username, required this.type});
  
  final users = <GithubUser>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final ScrollController scrollController = ScrollController();
  
  @override
  void onInit() {
    super.onInit();
    loadUsers();
    
    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && hasMore.value) {
          loadUsers();
        }
      }
    });
  }
  
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  
  /// Load users (followers or following)
  Future<void> loadUsers() async {
    if (isLoading.value) return;
    
    isLoading.value = true;
    
    try {
      final newUsers = type == UserListType.followers
          ? await repository.fetchFollowers(username, currentPage.value)
          : await repository.fetchFollowing(username, currentPage.value);
      
      if (newUsers.isEmpty) {
        hasMore.value = false;
      } else {
        users.addAll(newUsers);
        currentPage.value++;
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasMore.value = false;
      EasyLoading.showError(e.toString());
    }
  }
}
