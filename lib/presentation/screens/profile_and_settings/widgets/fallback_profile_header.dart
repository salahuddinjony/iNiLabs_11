import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';

/// Fallback profile header when user data is not available
class FallbackProfileHeader extends StatelessWidget {
  final String username;

  const FallbackProfileHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              username.isNotEmpty ? username : 'User',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            const Text('GitHub User'),
          ],
        ),
      ),
    );
  }
}
