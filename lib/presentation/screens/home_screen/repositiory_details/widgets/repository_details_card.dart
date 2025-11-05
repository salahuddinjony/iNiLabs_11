import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/utils/date_utils.dart' as app_date_utils;
import 'package:inilab/presentation/screens/home_screen/repositiory_details/widgets/details_row.dart';

/// Card displaying detailed repository information
class RepositoryDetailsCard extends StatelessWidget {
  final String? language;
  final String? createdAt;
  final String? updatedAt;
  final String? pushedAt;
  final String? license;
  final String? defaultBranch;
  final int size;
  final bool isPrivate;

  const RepositoryDetailsCard({
    super.key,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.license,
    this.defaultBranch,
    required this.size,
    required this.isPrivate,
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
              'Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            if (language != null)
              DetailRow(icon: Icons.code, label: 'Language', value: language!),
            if (createdAt != null)
              DetailRow(
                icon: Icons.calendar_today,
                label: 'Created',
                value: app_date_utils.DateUtils.formatDate(createdAt),
              ),
            if (updatedAt != null)
              DetailRow(
                icon: Icons.update,
                label: 'Updated',
                value: app_date_utils.DateUtils.formatDate(updatedAt),
              ),
            if (pushedAt != null)
              DetailRow(
                icon: Icons.push_pin,
                label: 'Last Push',
                value: app_date_utils.DateUtils.formatDate(pushedAt),
              ),
            if (license != null)
              DetailRow(icon: Icons.gavel, label: 'License', value: license!),
            if (defaultBranch != null)
              DetailRow(
                icon: Icons.device_hub,
                label: 'Default Branch',
                value: defaultBranch!,
              ),
            DetailRow(
              icon: Icons.storage,
              label: 'Size',
              value: '${(size / 1024).toStringAsFixed(2)} MB',
            ),
            DetailRow(
              icon: Icons.visibility,
              label: 'Visibility',
              value: isPrivate ? 'Private' : 'Public',
            ),
          ],
        ),
      ),
    );
  }
}
