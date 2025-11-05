import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';
import 'package:inilab/helper/extensions.dart';

/// Code viewer with line numbers
class CodeViewerWithLineNumbers extends StatelessWidget {
  final List<String> lines;
  final String fileName;

  const CodeViewerWithLineNumbers({
    super.key,
    required this.lines,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final numberWidth = (lines.length.toString().length * 8.0) + 16.0;
    final language = fileName.getLanguageFromFileName();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line numbers
        Container(
          width: numberWidth,
          padding: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(lines.length, (index) {
              return Container(
                height: 21.0, // Match line height
                alignment: Alignment.centerRight,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.outline,
                    height: 1.5,
                  ),
                ),
              );
            }),
          ),
        ),

        // Code content with syntax highlighting
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: HighlightView(
            lines.join('\n'),
            language: language,
            theme: themeController.isDarkMode ? vs2015Theme : vsTheme,
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
