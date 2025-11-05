import 'package:get/get.dart';
import 'package:inilab/core/utils/api_service.dart';
import 'package:inilab/data/models/github_user.dart';
import 'package:inilab/data/repositories/github_repository.dart';
import 'package:inilab/presentation/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for profile settings - Manages logged user only
class ProfileController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();
  final GithubRepository _repository = GithubRepository(ApiService());

  final Rx<GithubUser?> _user = Rx<GithubUser?>(null);
  final RxBool _isLoading = true.obs;
  final RxString _username = ''.obs;

  GithubUser? get user => _user.value;
  bool get isLoading => _isLoading.value;
  String get username => _username.value;
  bool get isDarkMode => _themeController.isDarkMode;

  @override
  void onInit() {
    super.onInit();
    _loadLoggedUser();
  }

  /// Load the logged-in user's data
  Future<void> _loadLoggedUser() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final loggedUsername = prefs.getString('username');

      if (loggedUsername != null && loggedUsername.isNotEmpty) {
        _username.value = loggedUsername;
        await fetchUserData(loggedUsername);
      }
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading.value = false;
    }
  }

  /// Fetch user data
  Future<void> fetchUserData(String username) async {
    try {
      final userData = await _repository.fetchUser(username);
      _user.value = userData;
    } catch (e) {
      // Handle error silently
    }
  }

  void toggleTheme() {
    _themeController.toggleTheme();
  }
}
