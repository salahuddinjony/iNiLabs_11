import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';

/// Card displaying repository topics as chips
class RepositoryTopicsCard extends StatelessWidget {
  final List<String> topics;

  const RepositoryTopicsCard({
    super.key,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Topics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics.map((topic) {
                return Chip(
                  label: Text(topic),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
