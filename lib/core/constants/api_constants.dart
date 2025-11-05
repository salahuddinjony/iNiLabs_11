import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Constants for GitHub API
class ApiConstants {

 
  // Base URL
  static const String baseUrl = 'https://api.github.com';

  // Endpoints
  static const String users = '/users';
  static const String repos = '/repos';
  static const String graphql = '/graphql';

  // Get user by username
  static String getUserUrl(String username) => '$baseUrl/users/$username';

  // Get user repositories
  static String getUserReposUrl(String username) =>
      '$baseUrl/users/$username/repos';

  // Get repository details
  static String getRepoDetailsUrl(String owner, String repoName) =>
      '$baseUrl/repos/$owner/$repoName';

  // Get repository contents
  static String getRepoContentsUrl(String owner, String repoName, [String path = '']) =>
      path.isEmpty
          ? '$baseUrl/repos/$owner/$repoName/contents'
          : '$baseUrl/repos/$owner/$repoName/contents/$path';

  // Get repository branches
  static String getRepoBranchesUrl(String owner, String repoName) =>
      '$baseUrl/repos/$owner/$repoName/branches';

  // Headers with authentication
  static Map<String, String> get headers {
    final token = dotenv.env['GITHUB_TOKEN'] ?? '';
    return {
      'Accept': 'application/vnd.github.v3+json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
