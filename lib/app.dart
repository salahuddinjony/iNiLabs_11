import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inilab/core/theme/app_theme.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:inilab/presentation/screens/home_screen.dart';
import 'package:inilab/presentation/screens/login_screen.dart';
import 'package:inilab/presentation/screens/repository_details_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme controller
    final themeController = Get.put(ThemeController());
    
    // Configure EasyLoading
    _configureEasyLoading();
    
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GitHub Repo Viewer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/repository-details',
          page: () => const RepositoryDetailsScreen(),
        ),
      ],
      builder: EasyLoading.init(),
    ));
  }
  
  void _configureEasyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black87
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
