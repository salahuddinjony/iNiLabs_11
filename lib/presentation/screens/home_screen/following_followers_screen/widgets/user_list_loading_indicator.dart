import 'package:flutter/material.dart';
import 'package:inilab/core/constants/app_constants.dart';

/// Loading indicator shown at the bottom of the list during pagination
class UserListLoadingIndicator extends StatelessWidget {
  const UserListLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
