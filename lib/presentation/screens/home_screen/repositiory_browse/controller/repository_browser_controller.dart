import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/api_constants.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/api_services/api_service.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/data/models/repository_content.dart';

/// Controller for browsing repository contents using GraphQL
class RepositoryBrowserController extends GetxController {
  final ApiService _apiService = ApiService();
  final repo_model.GithubRepository repository;
  
  final RxList<RepositoryContent> contents = <RepositoryContent>[].obs;
  final RxBool isLoading = true.obs;
  final Rxn<String> error = Rxn<String>();
  final RxList<String> pathStack = <String>[].obs;
  final RxString currentPath = ''.obs;

  RepositoryBrowserController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchContents('');
  }

  /// Fetch repository contents using REST API
  Future<void> fetchContents(String path) async {
    isLoading.value = true;
    error.value = null;
    currentPath.value = path;

    try {
      final owner = repository.owner.login;
      final repoName = repository.name;
      final branch = repository.defaultBranch ?? 'main';

      debugPrint('Fetching contents for: $owner/$repoName at path: $path');

      final response = await _apiService.get(
        ApiConstants.getRepoContentsUrl(owner, repoName, path),
        queryParameters: {'ref': branch},
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.data is List) {
        final List<RepositoryContent> items = [];
        for (var item in response.data) {
          items.add(RepositoryContent.fromJson(item));
        }

        // Sort: directories first, then files, alphabetically
        items.sort((a, b) {
          if (a.isDirectory && !b.isDirectory) return -1;
          if (!a.isDirectory && b.isDirectory) return 1;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        contents.value = items;
      } else {
        error.value = 'Unexpected response format';
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint('Error fetching contents: $e');
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  /// Navigate into a directory
  void navigateToDirectory(String path, String dirName) {
    pathStack.add(dirName);
    fetchContents(path);
  }

  /// Navigate back
  void navigateBack() {
    if (pathStack.isEmpty) return;

    pathStack.removeLast();
    final newPath = pathStack.join('/');
    fetchContents(newPath);
  }

  /// Handle back button press - navigate up in folder hierarchy or exit
  void handleBackPress(BuildContext context) {
    if (pathStack.isEmpty) {
      // At root level, exit the screen
      Navigator.of(context).pop();
    } else {
      // Navigate up one folder
      navigateBack();
    }
  }

  /// Get repository download URL (ZIP)
  String getDownloadUrl({String? branch}) {
    final owner = repository.owner.login;
    final repoName = repository.name;
    final selectedBranch = branch ?? repository.defaultBranch ?? 'main';
    return '${AppConstants.githubUrl}/$owner/$repoName/archive/refs/heads/$selectedBranch.zip';
  }

  /// Fetch available branches
  Future<List<String>> fetchBranches() async {
    try {
      final owner = repository.owner.login;
      final repoName = repository.name;

      final response = await _apiService.get(
        ApiConstants.getRepoBranchesUrl(owner, repoName),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((branch) => branch['name'] as String)
            .toList();
      }
      return [repository.defaultBranch ?? 'main'];
    } catch (e) {
      debugPrint('Error fetching branches: $e');
      return [repository.defaultBranch ?? 'main'];
    }
  }

  /// Get repository clone URL
  String getCloneUrl() {
    return repository.htmlUrl;
  }

  /// Get repository SSH URL
  String getSshUrl() {
    final owner = repository.owner.login;
    final repoName = repository.name;
    return 'git@github.com:$owner/$repoName.git';
  }

  /// Fetch file content
  Future<FileContent?> fetchFileContent(String path) async {
    try {
      final owner = repository.owner.login;
      final repoName = repository.name;

      final response = await _apiService.get(
        ApiConstants.getRepoContentsUrl(owner, repoName, path),
      );

      return FileContent.fromJson(response.data);
    } catch (e) {
      debugPrint('Error fetching file content: $e');
      return null;
    }
  }

  /// Decode base64 content
  String decodeContent(String base64Content) {
    try {
      // Remove whitespace and newlines
      final cleaned = base64Content.replaceAll(RegExp(r'\s'), '');
      final decoded = utf8.decode(base64.decode(cleaned));
      return decoded;
    } catch (e) {
      debugPrint('Error decoding content: $e');
      return 'Error decoding file content';
    }
  }

  /// Get current breadcrumb path
  String getBreadcrumb() {
    if (pathStack.isEmpty) return repository.name;
    return '${repository.name} / ${pathStack.join(' / ')}';
  }
}
