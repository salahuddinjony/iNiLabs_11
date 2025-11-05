import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/data/models/repository_content.dart';

/// Controller for browsing repository contents using GraphQL
class RepositoryBrowserController extends GetxController {
  static final String _githubToken = dotenv.env['GITHUB_TOKEN'] ?? '';

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
      final dio = Dio();
      final owner = repository.owner.login;
      final repoName = repository.name;
      final branch = repository.defaultBranch ?? 'main';

      debugPrint('Fetching contents for: $owner/$repoName at path: $path');

      final url = path.isEmpty
          ? 'https://api.github.com/repos/$owner/$repoName/contents'
          : 'https://api.github.com/repos/$owner/$repoName/contents/$path';

      final response = await dio.get(
        url,
        queryParameters: {'ref': branch},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_githubToken',
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
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

  /// Get repository download URL (ZIP)
  String getDownloadUrl({String? branch}) {
    final owner = repository.owner.login;
    final repoName = repository.name;
    final selectedBranch = branch ?? repository.defaultBranch ?? 'main';
    return 'https://github.com/$owner/$repoName/archive/refs/heads/$selectedBranch.zip';
  }

  /// Fetch available branches
  Future<List<String>> fetchBranches() async {
    try {
      final dio = Dio();
      final owner = repository.owner.login;
      final repoName = repository.name;

      final response = await dio.get(
        'https://api.github.com/repos/$owner/$repoName/branches',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_githubToken',
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
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
      final dio = Dio();
      final owner = repository.owner.login;
      final repoName = repository.name;

      final response = await dio.get(
        'https://api.github.com/repos/$owner/$repoName/contents/$path',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_githubToken',
            'Accept': 'application/vnd.github.v3+json',
          },
        ),
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
