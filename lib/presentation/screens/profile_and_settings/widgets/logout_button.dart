import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/presentation/screens/main_screen/controller/main_controller.dart';
import 'package:inilab/presentation/screens/profile_and_settings/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Logout button with confirmation dialog
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleLogout(context),
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      // Clean up specific controllers only, preserve ThemeController
      try {
        Get.delete<ProfileController>(force: true);
      } catch (e) {
        // Controller may not exist
      }

      try {
        Get.delete<MainController>(force: true);
      } catch (e) {
        // Controller may not exist
      }

      // Clear saved username
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');

      // Navigate to login
      if (context.mounted) {
        context.goNamed(RoutePath.login);
      }
    }
  }
}
