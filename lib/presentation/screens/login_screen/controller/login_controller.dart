import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/core/utils/api_services/api_service.dart';
import 'package:inilab/data/repositories/github_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Login Controller
class LoginController extends GetxController {
  final GithubRepository _repository = GithubRepository(ApiService());

  final usernameController = TextEditingController();

  // Observable variables
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  /// Validate and fetch user
  Future<bool> login(String username, BuildContext context) async {
    if (username.trim().isEmpty) {
      _errorMessage.value = 'Please enter a username';
      return false;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      await _repository.fetchUser(username.trim());
      _isLoading.value = false;
      // Navigate to main screen and save username
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username.trim());

      if (context.mounted) {
        context.goNamed(RoutePath.main);
        usernameController.clear();
      }
      return true;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = e.toString();

      EasyLoading.showError(e.toString());
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }
}
