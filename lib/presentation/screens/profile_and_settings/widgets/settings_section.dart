import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/theme_dialog.dart';

/// Settings section card with theme mode selector
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Text(
              'Settings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          // Theme Mode Selector
          Obx(
            () => ListTile(
              leading: Icon(themeController.themeIcon),
              title: const Text('Theme Mode'),
              subtitle: Text(themeController.currentThemeString),
              trailing: const Icon(
                Icons.chevron_right,
                size: 16,
              ),
              onTap: () => showThemeDialog(context, themeController),
            ),
          ),
        ],
      ),
    );
  }
}
