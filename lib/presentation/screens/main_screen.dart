import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inilab/presentation/controllers/home_controller.dart';
import 'package:inilab/presentation/controllers/main_controller.dart';
import 'package:inilab/presentation/screens/home_screen.dart';
import 'package:inilab/presentation/screens/profile_screen.dart';
import 'package:inilab/presentation/screens/user_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    
    if (mounted) {
      setState(() {
        _username = username;
        _isLoading = false;
      });
      
      // Initialize main controller and set current username
      if (username != null) {
        final mainController = Get.put(MainController());
        mainController.setCurrentUsername(username);
        
        // Initialize home controller with username
        final homeController = Get.put(HomeController(), tag: username);
        homeController.initialize(username);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final controller = Get.find<MainController>();

    return Obx(() {
      // Use the current username from MainController (might change when searching users)
      final currentUsername = controller.currentUsername.value.isNotEmpty 
          ? controller.currentUsername.value 
          : _username;

      final List<Widget> screens = [
        HomeScreen(username: currentUsername),
        const UserSearchScreen(),
        const ProfileScreen(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_search_outlined),
              selectedIcon: Icon(Icons.person_search),
              label: 'Users',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
