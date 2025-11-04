import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/data/models/github_user.dart';

/// GitHub Repository for API calls
class GithubRepository {
  final ApiService _apiService;
  
  GithubRepository(this._apiService);
  
  /// Fetch user by username
  Future<GithubUser> fetchUser(String username) async {
    try {
      final response = await _apiService.get('/users/$username');
      return GithubUser.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  
  /// Fetch user repositories
  Future<List<repo_model.GithubRepository>> fetchUserRepositories(
    String username, {
    String? sort,
    String? direction,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (sort != null) queryParams['sort'] = sort;
      if (direction != null) queryParams['direction'] = direction;
      
      final response = await _apiService.get(
        '/users/$username/repos',
        queryParameters: queryParams,
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => repo_model.GithubRepository.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  /// Fetch repository details
  Future<repo_model.GithubRepository> fetchRepositoryDetails(
    String owner,
    String repoName,
  ) async {
    try {
      final response = await _apiService.get('/repos/$owner/$repoName');
      return repo_model.GithubRepository.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  
  /// Fetch user followers
  Future<List<GithubUser>> fetchFollowers(String username, int page) async {
    try {
      final response = await _apiService.get(
        '/users/$username/followers',
        queryParameters: {
          'per_page': 100,
          'page': page,
        },
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => GithubUser.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  /// Fetch user following
  Future<List<GithubUser>> fetchFollowing(String username, int page) async {
    try {
      final response = await _apiService.get(
        '/users/$username/following',
        queryParameters: {
          'per_page': 100,
          'page': page,
        },
      );
      
      final List<dynamic> data = response.data;
      return data.map((json) => GithubUser.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
