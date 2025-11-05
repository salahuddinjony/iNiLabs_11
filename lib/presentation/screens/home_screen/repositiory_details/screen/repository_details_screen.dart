import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/repository_action_buttons.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/repository_details_card.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/repository_header.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/repository_stats_card.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/repository_topics_card.dart';

/// Repository Details Screen
class RepositoryDetailsScreen extends StatelessWidget {
  final repo_model.GithubRepository repository;

  const RepositoryDetailsScreen({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(repository.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository Header
            RepositoryHeader(
              fullName: repository.fullName,
              description: repository.description,
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Stats Card
            RepositoryStatsCard(
              stargazersCount: repository.stargazersCount,
              watchersCount: repository.watchersCount,
              forksCount: repository.forksCount,
              openIssuesCount: repository.openIssuesCount,
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Details Card
            RepositoryDetailsCard(
              language: repository.language,
              createdAt: repository.createdAt,
              updatedAt: repository.updatedAt,
              pushedAt: repository.pushedAt,
              license: repository.license,
              defaultBranch: repository.defaultBranch,
              size: repository.size,
              isPrivate: repository.private,
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Topics
            RepositoryTopicsCard(
              topics: repository.topics ?? [],
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Action Buttons
            RepositoryActionButtons(repository: repository),
          ],
        ),
      ),
    );
  }
}
