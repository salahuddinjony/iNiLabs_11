import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/core/constants/app_constants.dart';
import 'package:inilab/presentation/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GitHub Icon
                Icon(
                  Icons.code,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Title
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.paddingSmall),

                // Subtitle
                Text(
                  'Enter a GitHub username to view repositories',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.paddingLarge * 3),

                // Username TextField
                TextField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'GitHub Username',
                    hintText: 'e.g., torvalds',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) => controller.login(value, context),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Error message
                Obx(() {
                  if (controller.errorMessage.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: Text(
                              controller.errorMessage,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: AppConstants.paddingLarge),

                // Submit Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () => controller.login(
                              controller.usernameController.text,
                              context,
                            ),
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('View Repositories'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
