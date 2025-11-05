import 'package:flutter/material.dart';

/// Extension for file size formatting
extension FileSizeExtension on int {
  /// Format bytes to human-readable file size
  String toFileSize() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(1)} KB';
    }
    return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Extension for file icon detection
extension FileIconExtension on String {
  /// Get appropriate icon based on file extension
  IconData get fileIcon {
    final extension = split('.').last.toLowerCase();

    switch (extension) {
      case 'dart':
      case 'java':
      case 'kt':
      case 'swift':
      case 'cpp':
      case 'c':
      case 'h':
      case 'py':
        return Icons.code;
      case 'js':
      case 'ts':
      case 'jsx':
      case 'tsx':
        return Icons.javascript;
      case 'json':
        return Icons.data_object;
      case 'xml':
      case 'html':
        return Icons.web;
      case 'md':
      case 'txt':
        return Icons.description;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'svg':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
      case 'tar':
      case 'gz':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }
}

/// Extension for GitHub-like theme colors
extension GitHubColorsExtension on BuildContext {
  /// Get GitHub-like colors based on theme
  GitHubColors get githubColors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return GitHubColors(isDark: isDark);
  }
}

/// GitHub color scheme
class GitHubColors {
  final bool isDark;

  const GitHubColors({required this.isDark});

  Color get background => isDark ? const Color(0xFF161B22) : Colors.white;
  
  Color get surface => isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA);
  
  Color get border => isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);
  
  Color get primary => isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA);
  
  Color get text => isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F);
  
  Color get textSecondary => isDark ? const Color(0xFF8B949E) : const Color(0xFF57606A);
  
  Color get success => isDark ? const Color(0xFF238636) : const Color(0xFF2DA44E);
  
  Color get cardBackground => isDark ? const Color(0xFF21262D) : Colors.white;
}
