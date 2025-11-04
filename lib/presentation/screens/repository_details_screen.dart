import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/date_utils.dart' as app_date_utils;
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Repository Details Screen
class RepositoryDetailsScreen extends StatelessWidget {
  const RepositoryDetailsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final repo_model.GithubRepository repository = Get.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              themeController.isDarkMode 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
            ),
            onPressed: () => themeController.toggleTheme(),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository Name
            Text(
              repository.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Description
            if (repository.description != null && repository.description!.isNotEmpty)
              Text(
                repository.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          context,
                          Icons.star,
                          'Stars',
                          app_date_utils.DateUtils.formatNumber(repository.stargazersCount),
                        ),
                        _buildStatColumn(
                          context,
                          Icons.remove_red_eye,
                          'Watchers',
                          app_date_utils.DateUtils.formatNumber(repository.watchersCount),
                        ),
                        _buildStatColumn(
                          context,
                          Icons.fork_right,
                          'Forks',
                          app_date_utils.DateUtils.formatNumber(repository.forksCount),
                        ),
                        _buildStatColumn(
                          context,
                          Icons.bug_report,
                          'Issues',
                          app_date_utils.DateUtils.formatNumber(repository.openIssuesCount),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    if (repository.language != null)
                      _buildDetailRow(
                        context,
                        Icons.code,
                        'Language',
                        repository.language!,
                      ),
                    
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Created',
                      app_date_utils.DateUtils.formatDate(repository.createdAt),
                    ),
                    
                    _buildDetailRow(
                      context,
                      Icons.update,
                      'Updated',
                      app_date_utils.DateUtils.formatDate(repository.updatedAt),
                    ),
                    
                    _buildDetailRow(
                      context,
                      Icons.push_pin,
                      'Last Push',
                      app_date_utils.DateUtils.formatDate(repository.pushedAt),
                    ),
                    
                    if (repository.license != null)
                      _buildDetailRow(
                        context,
                        Icons.gavel,
                        'License',
                        repository.license!,
                      ),
                    
                    if (repository.defaultBranch != null)
                      _buildDetailRow(
                        context,
                        Icons.device_hub,
                        'Default Branch',
                        repository.defaultBranch!,
                      ),
                    
                    _buildDetailRow(
                      context,
                      Icons.storage,
                      'Size',
                      '${(repository.size / 1024).toStringAsFixed(2)} MB',
                    ),
                    
                    _buildDetailRow(
                      context,
                      Icons.visibility,
                      'Visibility',
                      repository.private ? 'Private' : 'Public',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Topics
            if (repository.topics != null && repository.topics!.isNotEmpty)
              Card(
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
                        children: repository.topics!.map((topic) {
                          return Chip(
                            label: Text(topic),
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(repository.htmlUrl),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('View on GitHub'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatColumn(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: AppConstants.iconSizeLarge),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          Icon(icon, size: AppConstants.iconSizeSmall),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      EasyLoading.showError('Could not open URL');
    }
  }
}
