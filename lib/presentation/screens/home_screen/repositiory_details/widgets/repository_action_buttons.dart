import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/helper/extention.dart';

/// Action buttons for browsing files and viewing on GitHub
class RepositoryActionButtons extends StatelessWidget {
  final repo_model.GithubRepository repository;

  const RepositoryActionButtons({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.pushNamed(
              RoutePath.repositoryBrowser,
              extra: repository,
            ),
            icon: const Icon(Icons.folder_open),
            label: const Text('Browse Files'),
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => repository.htmlUrl.launchExternal(),
            icon: const Icon(Icons.open_in_browser),
            label: const Text('View on GitHub'),
          ),
        ),
      ],
    );
  }
}
