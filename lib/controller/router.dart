import 'package:e_alerto/controller/routes.dart';
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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.loginPage,
  routes: [
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: Routes.registrationPage,
      builder: (context, state) => RegistrationScreen(),
    ),


    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.homePage,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: Routes.detailPage, // Ensure this has a parameter
                  builder: (context, state) {
                    return DetailScreen(
                      reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
                      classification: state.uri.queryParameters['classification'] ?? '',
                      location: state.uri.queryParameters['location'] ?? '',
                      status: state.uri.queryParameters['status'] ?? '',
                      date: state.uri.queryParameters['date'] ?? '',
                      username: state.uri.queryParameters['username'] ?? '',
                      description: state.uri.queryParameters['description'] ?? '',
                      //image: state.uri.queryParameters['image'] ?? '', extra: {},
                      extra: state.extra as Map<String, dynamic>? ?? {},
                    );
                  },
                ),
              ]
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.searchPage,
              builder: (context, state) => const SearchScreen(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.reportPage,
              builder: (context, state) => ReportScreen(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.notificationPage,
              builder: (context, state) => NotificationScreen(), // replace diz
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profilePage,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: Routes.settingsPage,
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  path: Routes.ratingPage,
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    return RatingScreen(
                      reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
                      classification: state.uri.queryParameters['classification'] ?? '',
                      location: state.uri.queryParameters['location'] ?? '',
                      status: state.uri.queryParameters['status'] ?? '',
                      date: state.uri.queryParameters['date'] ?? '',
                      username: state.uri.queryParameters['username'] ?? '',
                      description: state.uri.queryParameters['description'] ?? '',
                      image: extra['image'] ?? '', // ✅ Extract from `extra`
                    );
                  },
                ),
              ]
            )
          ]
        )
      ]
    ),
  ],
);
