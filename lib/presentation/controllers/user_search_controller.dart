import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/data/repositories/github_repository.dart';

/// Controller for user search functionality
class UserSearchController extends GetxController {
  final GithubRepository _repository = GithubRepository(ApiService());
  
  final searchResults = <GithubUser>[].obs;
  final isSearching = false.obs;
  final searchQuery = ''.obs;
  
  /// Search for users by username
  Future<void> searchUsers(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    
    if (query.length < 2) {
      return;
    }
    
    isSearching.value = true;
    
    try {
      final results = await _repository.searchUsers(query);
      searchResults.value = results;
      isSearching.value = false;
    } catch (e) {
      isSearching.value = false;
      EasyLoading.showError('Failed to search users: ${e.toString()}');
    }
  }
  
  /// Clear search results
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }
}
