import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/core/common_widgets/loading_widget.dart';
import 'package:inilab/presentation/screens/profile_and_settings/controller/profile_controller.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/about_section.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/developer_info_section.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/fallback_profile_header.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/logout_button.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/profile_header.dart';
import 'package:inilab/presentation/screens/profile_and_settings/widgets/settings_section.dart';

/// Profile settings screen - Shows logged user only
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Profile & Settings'),
            floating: true,
            snap: true,
          ),

          // Profile Header - Logged User Only
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(AppConstants.paddingLarge),
                  child: LoadingWidget(message: 'Loading profile...'),
                );
              }

              final user = controller.user;
              if (user == null) {
                return FallbackProfileHeader(username: controller.username);
              }

              return ProfileHeader(user: user);
            }),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppConstants.paddingMedium),

                // Settings Section
                const SettingsSection(),

                const SizedBox(height: AppConstants.paddingMedium),

                // Developer Info Section
                const DeveloperInfoSection(),

                const SizedBox(height: AppConstants.paddingMedium),

                // About Section
                const AboutSection(),

                const SizedBox(height: AppConstants.paddingMedium),

                // Logout Button
                const LogoutButton(),

                const SizedBox(height: AppConstants.paddingLarge),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
