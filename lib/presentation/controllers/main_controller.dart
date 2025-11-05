import 'package:get/get.dart';

/// Main controller for bottom navigation
class MainController extends GetxController {
  final selectedIndex = 0.obs;
  final currentUsername = ''.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void setCurrentUsername(String username) {
    currentUsername.value = username;
  }
}
