import 'package:get/get.dart';
import 'package:inilab/presentation/controllers/login_controller.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    // Theme controller is already initialized in main.dart
    // No need to initialize it here
    
    // Lazy load other controllers when needed
    Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true);
  }
}
