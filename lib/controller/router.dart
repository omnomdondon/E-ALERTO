import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/layout_scaffold.dart';

// Screens
import 'package:e_alerto/view/screens/home_screen.dart';
import 'package:e_alerto/view/screens/search_screen.dart';
import 'package:e_alerto/view/screens/notification_screen.dart';
import 'package:e_alerto/view/screens/profile_screen.dart';
import 'package:e_alerto/view/screens/report_screen.dart';
import 'package:e_alerto/view/screens/camera_screen.dart';
import 'package:e_alerto/view/screens/login_screen.dart';
import 'package:e_alerto/view/screens/registration_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.loginPage,
    routes: [
      GoRoute(
        path: Routes.loginPage,
        name: 'login',
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: Routes.registrationPage,
        name: 'registration',
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegistrationScreen()),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return LayoutScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.homePage,
                name: 'home',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.searchPage,
                name: 'search',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: SearchScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reportPage,
                name: 'report',
                pageBuilder: (context, state) {
                  final imagePath = state.extra as String?;
                  return MaterialPage(
                    child: ReportScreen(imagePath: imagePath),
                  );
                },
                routes: [
                  GoRoute(
                    path: Routes.cameraPage,
                    name: 'camera',
                    pageBuilder: (context, state) =>
                        const MaterialPage(child: CameraScreen()),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.notificationPage,
                name: 'notifications',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: NotificationScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profilePage,
                name: 'profile',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
