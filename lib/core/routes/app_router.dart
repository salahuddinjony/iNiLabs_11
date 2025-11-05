import 'package:go_router/go_router.dart';
import 'package:inilab/core/enums/enums.dart';
import 'package:inilab/core/routes/route_path.dart';
import 'package:inilab/data/models/github_repository.dart' as repo_model;
import 'package:inilab/helper/extention.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/controller/repository_browser_controller.dart';
import 'package:inilab/presentation/screens/home_screen/file_viewer_screen/screen/file_viewer_screen.dart';
import 'package:inilab/presentation/screens/home_screen/home/screen/home_screen.dart';
import 'package:inilab/presentation/screens/login_screen/screen/login_screen.dart';
import 'package:inilab/presentation/screens/main_screen/screen/main_screen.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_browse/screen/repository_browser_screen.dart';
import 'package:inilab/presentation/screens/home_screen/repositiory_details/screen/repository_details_screen.dart';
import 'package:inilab/presentation/screens/splash_screen/screen/splash_screen.dart';
import 'package:inilab/presentation/screens/home_screen/following_followers_screen/screen/user_list_screen.dart';

class AppRouter {
  static final GoRouter route = GoRouter(
    initialLocation: RoutePath.splash.addBasePath,
    routes: [
      GoRoute(
        path: RoutePath.splash.addBasePath,
        name: RoutePath.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePath.login.addBasePath,
        name: RoutePath.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RoutePath.main.addBasePath,
        name:  RoutePath.main,
        builder: (context, state) =>  MainScreen(),
      ),
      GoRoute(
        path: RoutePath.home.addBasePath,
        name:  RoutePath.home,
        builder: (context, state) {
          // Username and navigation flag passed as extra
          final extra = state.extra;
          
          if (extra is Map<String, dynamic>) {
            return HomeScreen(
              username: extra['username'] as String?,
              isFromNavigation: extra['isFromNavigation'] as bool? ?? false,
            );
          } else if (extra is String) {
            return HomeScreen(username: extra);
          }
          
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: RoutePath.repositoryDetails.addBasePath,
        name: RoutePath.repositoryDetails,
        builder: (context, state) {
          // Repository data passed as extra
          final repository = state.extra as repo_model.GithubRepository;
          return RepositoryDetailsScreen(repository: repository);
        },
      ),
      GoRoute(
        path: RoutePath.userList.addBasePath,
        name: RoutePath.userList,
        builder: (context, state) {
          // User list data passed as extra (Map with username and type)
          final data = state.extra as Map<String, dynamic>;
          return UserListScreen(
            username: data['username'] as String,
            type: data['type'] as UserListType,
          );
        },
      ),
      GoRoute(
        path: RoutePath.repositoryBrowser.addBasePath,
        name: RoutePath.repositoryBrowser,
        builder: (context, state) {
          // Repository data passed as extra
          final repository = state.extra as repo_model.GithubRepository;
          return RepositoryBrowserScreen(repository: repository);
        },
      ),
      GoRoute(
        path: RoutePath.fileViewer.addBasePath,
        name: RoutePath.fileViewer,
        builder: (context, state) {
          // File viewer data passed as extra
          final data = state.extra as Map<String, dynamic>;
          return FileViewerScreen(
            controller: data['controller'] as RepositoryBrowserController,
            filePath: data['filePath'] as String,
            fileName: data['fileName'] as String,
          );
        },
      ),
    ],
  );
}
