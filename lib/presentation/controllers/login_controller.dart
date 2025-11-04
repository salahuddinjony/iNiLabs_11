import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/repositories/github_repository.dart';

/// Login Controller
class LoginController extends GetxController {
  final GithubRepository _repository = GithubRepository(ApiService());
  
  // Observable variables
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  /// Validate and fetch user
  Future<bool> login(String username) async {
    if (username.trim().isEmpty) {
      _errorMessage.value = 'Please enter a username';
      EasyLoading.showError('Please enter a username');
      return false;
    }
    
    _isLoading.value = true;
    _errorMessage.value = '';
    // EasyLoading.show(status: 'Loading...');
    
    try {
      await _repository.fetchUser(username.trim());
      _isLoading.value = false;
      // Navigate to home with username
      Get.offNamed('/home', arguments: username.trim());
      return true;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = e.toString();
      
      EasyLoading.showError(e.toString());
      return false;
    }finally {
      EasyLoading.dismiss();
    }
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }
}
