import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:inilab/core/bindings/dependency_injection.dart';
import 'package:inilab/core/routes/app_router.dart';
import 'package:inilab/core/theme/app_theme.dart';
import 'package:inilab/core/common_controllers/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Height=========${MediaQuery.of(context).size.height}");
    debugPrint("Weight=========${MediaQuery.of(context).size.width}");
    
    // Initialize dependencies first
    DependencyInjection().dependencies();

    
    return ScreenUtilInit(
      designSize: const Size(411, 890),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        // Get theme controller
        final themeController = Get.find<ThemeController>();
    
        
        return Obx(() => GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Repo Finder',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          routeInformationParser: AppRouter.route.routeInformationParser,
          routerDelegate: AppRouter.route.routerDelegate,
          routeInformationProvider: AppRouter.route.routeInformationProvider,
          builder: EasyLoading.init(),
          
        ));
        
      },
    );
  }
  

}
