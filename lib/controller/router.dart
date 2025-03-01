import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/layout_scaffold.dart';
import 'package:e_alerto/view/screens/home_screen.dart';
import 'package:e_alerto/view/screens/login_screen.dart';
import 'package:e_alerto/view/screens/profile_screen.dart';
import 'package:e_alerto/view/screens/registration_screen.dart';
import 'package:e_alerto/view/screens/search_screen.dart';
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
              path: Routes.profilePage,
              builder: (context, state) => const ProfileScreen(),
            )
          ]
        )
      ]
    ),
  ],
);
