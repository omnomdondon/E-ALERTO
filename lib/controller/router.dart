import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/auth_gate.dart';
import 'package:e_alerto/view/layout_scaffold.dart';
import 'package:e_alerto/view/screens/detail_screen.dart';
import 'package:e_alerto/view/screens/home_screen.dart';
import 'package:e_alerto/view/screens/login_screen.dart';
import 'package:e_alerto/view/screens/notification_screen.dart';
import 'package:e_alerto/view/screens/profile_screen.dart';
import 'package:e_alerto/view/screens/rating_screen.dart';
import 'package:e_alerto/view/screens/registration_screen.dart';
import 'package:e_alerto/view/screens/report_screen.dart';
import 'package:e_alerto/view/screens/search_screen.dart';
import 'package:e_alerto/view/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter(GoogleSignIn googleSignIn) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.auth,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final User? user = FirebaseAuth.instance.currentUser;
      final bool isAuthPath = state.matchedLocation.startsWith(Routes.auth);

      debugPrint(
          'Router redirect - path: ${state.matchedLocation}, user: ${user?.uid}');

      // User not signed in and trying to access protected route
      if (user == null && !isAuthPath) {
        return Routes.loginPage;
      }

      // User signed in and trying to access auth route
      if (user != null && isAuthPath) {
        return Routes.homePage;
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.auth,
        name: 'auth',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            child: AuthGate(googleSignIn: googleSignIn),
          );
        },
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                child: LoginScreen(googleSignIn: googleSignIn),
              );
            },
          ),
          GoRoute(
            path: 'registration',
            name: 'registration',
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                child: RegistrationScreen(googleSignIn: googleSignIn),
              );
            },
          ),
        ],
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
                pageBuilder: (context, state) {
                  return const MaterialPage<void>(child: HomeScreen());
                },
                routes: [
                  GoRoute(
                    path: Routes.detailPage,
                    name: 'detail',
                    pageBuilder: (context, state) {
                      return MaterialPage<void>(
                        child: DetailScreen(
                          reportNumber:
                              state.uri.queryParameters['reportNumber'] ?? '',
                          classification:
                              state.uri.queryParameters['classification'] ?? '',
                          location: state.uri.queryParameters['location'] ?? '',
                          status: state.uri.queryParameters['status'] ?? '',
                          date: state.uri.queryParameters['date'] ?? '',
                          username: state.uri.queryParameters['username'] ?? '',
                          description:
                              state.uri.queryParameters['description'] ?? '',
                          extra: state.extra as Map<String, dynamic>? ?? {},
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.searchPage,
                name: 'search',
                pageBuilder: (context, state) {
                  return const MaterialPage<void>(child: SearchScreen());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reportPage,
                name: 'report',
                pageBuilder: (context, state) {
                  return const MaterialPage<void>(child: ReportScreen());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.notificationPage,
                name: 'notifications',
                pageBuilder: (context, state) {
                  return const MaterialPage<void>(child: NotificationScreen());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profilePage,
                name: 'profile',
                pageBuilder: (context, state) {
                  return const MaterialPage<void>(child: ProfileScreen());
                },
                routes: [
                  GoRoute(
                    path: Routes.settingsPage,
                    name: 'settings',
                    pageBuilder: (context, state) {
                      return const MaterialPage<void>(child: SettingsScreen());
                    },
                  ),
                  GoRoute(
                    path: Routes.ratingPage,
                    name: 'rating',
                    pageBuilder: (context, state) {
                      return MaterialPage<void>(
                        child: RatingScreen(
                          reportNumber:
                              state.uri.queryParameters['reportNumber'] ?? '',
                          classification:
                              state.uri.queryParameters['classification'] ?? '',
                          location: state.uri.queryParameters['location'] ?? '',
                          status: state.uri.queryParameters['status'] ?? '',
                          date: state.uri.queryParameters['date'] ?? '',
                          username: state.uri.queryParameters['username'] ?? '',
                          description:
                              state.uri.queryParameters['description'] ?? '',
                          image: (state.extra
                                  as Map<String, dynamic>?)?['image'] ??
                              '',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
