import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/date_utils.dart' as app_date_utils;

/// Card displaying repository statistics (stars, watchers, forks, issues)
class RepositoryStatsCard extends StatelessWidget {
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;

  const RepositoryStatsCard({
    super.key,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                _StatColumn(
                  icon: Icons.star,
                  label: 'Stars',
                  value: app_date_utils.DateUtils.formatNumber(stargazersCount),
                ),
                _StatColumn(
                  icon: Icons.remove_red_eye,
                  label: 'Watchers',
                  value: app_date_utils.DateUtils.formatNumber(watchersCount),
                ),
                _StatColumn(
                  icon: Icons.fork_right,
                  label: 'Forks',
                  value: app_date_utils.DateUtils.formatNumber(forksCount),
                ),
                _StatColumn(
                  icon: Icons.bug_report,
                  label: 'Issues',
                  value: app_date_utils.DateUtils.formatNumber(openIssuesCount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget for displaying a single statistic column
class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}
