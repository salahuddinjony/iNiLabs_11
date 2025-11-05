import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/presentation/screens/home_screen/home/widgets/user_avatar.dart';
import 'package:inilab/core/common_widgets/github_snackbar.dart';

/// Widget displaying the user's profile header with avatar, name, bio, and stats
class ProfileHeader extends StatelessWidget {
  final GithubUser user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            // Avatar with border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: UserAvatar(imageUrl: user.avatarUrl, size: 80),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Name
            Text(
              user.name ?? user.login,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Username with copy
            const SizedBox(height: 4),
            _UsernameWithCopy(username: user.login),

            // Bio
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                user.bio!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: AppConstants.paddingMedium),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatChip(
                  context: context,
                  icon: Icons.code,
                  label: 'Repos',
                  value: user.publicRepos.toString(),
                ),
                _StatChip(
                  context: context,
                  icon: Icons.people,
                  label: 'Followers',
                  value: user.followers.toString(),
                ),
                _StatChip(
                  context: context,
                  icon: Icons.person_add,
                  label: 'Following',
                  value: user.following.toString(),
                ),
              ],
            ),

            // Quick Info
            if (user.location != null ||
                user.company != null ||
                user.email != null) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              const Divider(),
              const SizedBox(height: AppConstants.paddingSmall),
              _UserQuickInfo(user: user),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal widget for username with copy functionality
class _UsernameWithCopy extends StatelessWidget {
  final String username;

  const _UsernameWithCopy({required this.username});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: username));
        GitHubSnackBar.show(
          context,
          message: 'Username copied to clipboard',
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '@$username',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.copy,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget for displaying a single statistic
class _StatChip extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.context,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// Internal widget for displaying user's quick info (location, company, email)
class _UserQuickInfo extends StatelessWidget {
  final GithubUser user;

  const _UserQuickInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        if (user.location != null)
          _InfoChip(
            context: context,
            icon: Icons.location_on,
            text: user.location!,
          ),
        if (user.company != null)
          _InfoChip(
            context: context,
            icon: Icons.business,
            text: user.company!,
          ),
        if (user.email != null)
          _InfoChip(
            context: context,
            icon: Icons.email,
            text: user.email!,
          ),
      ],
    );
  }
}

/// Internal widget for displaying an info chip
class _InfoChip extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.context,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
