import 'package:get/get.dart';
import 'package:inilab/presentation/screens/login_screen/controller/login_controller.dart';
import 'package:inilab/presentation/screens/home_screen/home/controller/home_controller.dart';
import 'package:inilab/presentation/screens/main_screen/controller/main_controller.dart';
import 'package:inilab/presentation/screens/profile_and_settings/controller/profile_controller.dart';
import 'package:inilab/presentation/screens/users_screen/controller/user_search_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<MainController>(() => MainController(),fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(),fenix: true);
    Get.lazyPut<UserSearchController>(() => UserSearchController(),fenix: true);

  }
}
