/// GitHub Repository Model
class GithubRepository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final bool private;
  final String htmlUrl;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String? createdAt;
  final String? updatedAt;
  final String? pushedAt;
  final int size;
  final String? defaultBranch;
  final Owner owner;
  final bool fork;
  final String? license;
  final List<String>? topics;
  
  GithubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.private,
    required this.htmlUrl,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    required this.size,
    this.defaultBranch,
    required this.owner,
    required this.fork,
    this.license,
    this.topics,
  });
  
  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    return GithubRepository(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'],
      private: json['private'] ?? false,
      htmlUrl: json['html_url'] ?? '',
      language: json['language'],
      stargazersCount: json['stargazers_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pushedAt: json['pushed_at'],
      size: json['size'] ?? 0,
      defaultBranch: json['default_branch'],
      owner: Owner.fromJson(json['owner'] ?? {}),
      fork: json['fork'] ?? false,
      license: json['license']?['name'],
      topics: json['topics'] != null 
          ? List<String>.from(json['topics']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'private': private,
      'html_url': htmlUrl,
      'language': language,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pushed_at': pushedAt,
      'size': size,
      'default_branch': defaultBranch,
      'owner': owner.toJson(),
      'fork': fork,
      'license': license,
      'topics': topics,
    };
  }
}

/// Repository Owner Model
class Owner {
  final String login;
  final int id;
  final String? avatarUrl;
  
  Owner({
    required this.login,
    required this.id,
    this.avatarUrl,
  });
  
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'] ?? '',
      id: json['id'] ?? 0,
      avatarUrl: json['avatar_url'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'avatar_url': avatarUrl,
    };
  }
}
