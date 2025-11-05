/// Model for repository content (files and directories)
class RepositoryContent {
  final String name;
  final String path;
  final String type; // 'file' or 'dir'
  final int? size;
  final String? sha;
  final String? downloadUrl;
  final String? htmlUrl;

  RepositoryContent({
    required this.name,
    required this.path,
    required this.type,
    this.size,
    this.sha,
    this.downloadUrl,
    this.htmlUrl,
  });

  factory RepositoryContent.fromJson(Map<String, dynamic> json) {
    return RepositoryContent(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      type: json['type'] ?? '',
      size: json['size'],
      sha: json['sha'],
      downloadUrl: json['download_url'],
      htmlUrl: json['html_url'],
    );
  }

  bool get isDirectory => type == 'dir';
  bool get isFile => type == 'file';
}

/// Model for file content
class FileContent {
  final String name;
  final String path;
  final String content;
  final String encoding;
  final int size;
  final String? sha;
  final String? htmlUrl;

  FileContent({
    required this.name,
    required this.path,
    required this.content,
    required this.encoding,
    required this.size,
    this.sha,
    this.htmlUrl,
  });

  factory FileContent.fromJson(Map<String, dynamic> json) {
    return FileContent(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      content: json['content'] ?? '',
      encoding: json['encoding'] ?? '',
      size: json['size'] ?? 0,
      sha: json['sha'],
      htmlUrl: json['html_url'],
    );
  }
}
