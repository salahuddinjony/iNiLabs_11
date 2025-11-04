import 'package:get/get.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:inilab/presentation/controllers/login_controller.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    // Initialize theme controller
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    
    // Lazy load other controllers when needed
    Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true);
  }
}
