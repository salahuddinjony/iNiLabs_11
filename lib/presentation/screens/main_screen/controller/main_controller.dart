import 'package:get/get.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main controller for bottom navigation
class MainController extends GetxController {
  final selectedIndex = 0.obs;
  final currentUsername = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsername();
  }

  /// Load username from SharedPreferences
  Future<void> loadUsername() async {
    isLoading.value = true;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      
      if (username != null) {
        currentUsername.value = username;
        
        // Initialize home controller with username
        final homeController = (Get.isRegistered<HomeController>()
            ? Get.find<HomeController>(tag: username)
            : Get.put(HomeController(), tag: username));

        homeController.initialize(username);
      }
    } catch (e) {
      // Handle error silently or log it
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void setCurrentUsername(String username) {
    currentUsername.value = username;
  }
}
