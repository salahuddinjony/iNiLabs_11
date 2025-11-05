import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';

/// Widget displaying the repository name and description
class RepositoryHeader extends StatelessWidget {
  final String fullName;
  final String? description;

  const RepositoryHeader({
    super.key,
    required this.fullName,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}
