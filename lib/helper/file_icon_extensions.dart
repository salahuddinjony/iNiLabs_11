import 'package:flutter/material.dart';

/// Extension for getting file icons based on file extension
extension FileIconExtension on String {
  /// Get icon for file based on its extension
  IconData getFileIcon() {
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
      default:
        return Icons.insert_drive_file;
    }
  }
}

/// Extension for formatting file sizes
extension FileSizeExtension on int {
  /// Format file size in bytes to human-readable format
  String formatFileSize() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(1)} KB';
    }
    return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
