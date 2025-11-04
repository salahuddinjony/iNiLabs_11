import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/date_utils.dart' as app_date_utils;
import 'package:inilab/data/models/github_repository.dart' as repo_model;

/// Repository card widget for list view
class RepositoryCard extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final VoidCallback onTap;
  
  const RepositoryCard({
    super.key,
    required this.repository,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repository name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      repository.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (repository.private)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Private',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                ],
              ),
              
              // Description
              if (repository.description != null && repository.description!.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  repository.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Stats
              Wrap(
                spacing: AppConstants.paddingMedium,
                runSpacing: AppConstants.paddingSmall,
                children: [
                  if (repository.language != null)
                    _buildStat(
                      context,
                      Icons.circle,
                      repository.language!,
                      _getLanguageColor(repository.language!),
                    ),
                  _buildStat(
                    context,
                    Icons.star_border,
                    app_date_utils.DateUtils.formatNumber(repository.stargazersCount),
                    null,
                  ),
                  _buildStat(
                    context,
                    Icons.fork_right,
                    app_date_utils.DateUtils.formatNumber(repository.forksCount),
                    null,
                  ),
                  Text(
                    'Updated ${app_date_utils.DateUtils.getRelativeTime(repository.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat(BuildContext context, IconData icon, String text, Color? color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  Color _getLanguageColor(String language) {
    final colors = {
      'Dart': const Color(0xFF00B4AB),
      'JavaScript': const Color(0xFFF7DF1E),
      'TypeScript': const Color(0xFF3178C6),
      'Python': const Color(0xFF3776AB),
      'Java': const Color(0xFFB07219),
      'Kotlin': const Color(0xFFA97BFF),
      'Swift': const Color(0xFFFA7343),
      'Go': const Color(0xFF00ADD8),
      'Rust': const Color(0xFFDEA584),
      'C++': const Color(0xFFF34B7D),
      'C': const Color(0xFF555555),
      'Ruby': const Color(0xFF701516),
      'PHP': const Color(0xFF4F5D95),
    };
    
    return colors[language] ?? Colors.grey;
  }
}
