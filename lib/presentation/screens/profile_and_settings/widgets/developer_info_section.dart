import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/helper/extention.dart';

/// Developer info section card with app version and links
class DeveloperInfoSection extends StatelessWidget {
  const DeveloperInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Text(
              'Developer Info',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),

          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Developer Portfolio'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () => AppConstants.developerPortfolioUrl.launchExternal(),
          ),

          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Report Issue'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () => AppConstants.supportUrl.launchExternal(),
          ),

          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Rate App'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () => AppConstants.ratingUrl.launchExternal(),
          ),
        ],
      ),
    );
  }
}
