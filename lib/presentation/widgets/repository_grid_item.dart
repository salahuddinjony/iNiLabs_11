import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/date_utils.dart' as app_date_utils;
import 'package:inilab/data/models/github_repository.dart' as repo_model;

/// Repository grid item widget for grid view
class RepositoryGridItem extends StatelessWidget {
  final repo_model.GithubRepository repository;
  final VoidCallback onTap;
  
  const RepositoryGridItem({
    super.key,
    required this.repository,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              // Description
              Expanded(
                child: Text(
                  repository.description ?? 'No description',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              // Language
              if (repository.language != null)
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: _getLanguageColor(repository.language!),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        repository.language!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              // Stars
              Row(
                children: [
                  const Icon(Icons.star_border, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    app_date_utils.DateUtils.formatNumber(repository.stargazersCount),
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
