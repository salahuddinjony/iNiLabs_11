import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';

/// Shows a dialog for selecting the theme mode
void showThemeDialog(BuildContext context, ThemeController themeController) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.brightness_auto),
                  SizedBox(width: 8),
                  Text('System'),
                ],
              ),
              subtitle: const Text('Follow device theme'),
              value: ThemeMode.system,
              groupValue: themeController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeController.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Obx(
            () => RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.light_mode),
                  SizedBox(width: 8),
                  Text('Light'),
                ],
              ),
              subtitle: const Text('Light theme'),
              value: ThemeMode.light,
              groupValue: themeController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeController.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Obx(
            () => RadioListTile<ThemeMode>(
              title: const Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 8),
                  Text('Dark'),
                ],
              ),
              subtitle: const Text('Dark theme'),
              value: ThemeMode.dark,
              groupValue: themeController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeController.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}
