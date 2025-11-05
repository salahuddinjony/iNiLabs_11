import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';
import 'package:inilab/helper/extensions.dart';

/// Code viewer without line numbers
class CodeViewerWithoutLineNumbers extends StatelessWidget {
  final String content;
  final String fileName;

  const CodeViewerWithoutLineNumbers({
    super.key,
    required this.content,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final language = fileName.getLanguageFromFileName();

    return HighlightView(
      content,
      language: language,
      theme: themeController.isDarkMode ? vs2015Theme : vsTheme,
      padding: EdgeInsets.zero,
      textStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12.sp,
        height: 1.5,
      ),
    );
  }
}
