import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:go_router/go_router.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/layout_scaffold.dart';

// Screens
import 'package:e_alerto/view/screens/home_screen.dart';
import 'package:e_alerto/view/screens/detail_screen.dart';
import 'package:e_alerto/view/screens/search_screen.dart';
import 'package:e_alerto/view/screens/notification_screen.dart';
import 'package:e_alerto/view/screens/profile_screen.dart';
import 'package:e_alerto/view/screens/settings_screen.dart';
import 'package:e_alerto/view/screens/report_screen.dart';
import 'package:e_alerto/view/screens/camera_screen.dart';
import 'package:e_alerto/view/screens/login_screen.dart';
import 'package:e_alerto/view/screens/registration_screen.dart';
import 'package:e_alerto/view/screens/rating_screen.dart';

import '../view/screens/continue_to_otp_screen.dart';
import '../view/screens/otp_verification_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.searchPage,
    routes: [
      // Login Screen
      GoRoute(
        path: Routes.loginPage,
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),

      // Registration Screen
      GoRoute(
        path: Routes.registrationPage,
        name: 'registration',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegistrationScreen()),
      ),

      GoRoute(
        path: '/continue-otp',
        name: 'continueOtp',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return MaterialPage(
            child: ContinueToOTPScreen(
              email: extra['email']!,
              phone: extra['phone']!,
              username: extra['username']!,
            ),
          );
        },
      ),

      GoRoute(
        path: '/otp',
        name: 'otp',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return MaterialPage(
            child: OTPVerificationScreen(
              email: extra['email']!,
              phone: extra['phone']!,
              username: extra['username']!,
            ),
          );
        },
      ),

      // Main App Shell (Navigation starts after login)
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return LayoutScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.homePage,
                name: 'home',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: HomeScreen()),
                routes: [
                  // For home detail
                  GoRoute(
                    path: '/home/detail/:reportNumber',
                    name: 'homeDetail',
                    pageBuilder: (context, state) {
                      final reportNumber =
                          state.pathParameters['reportNumber'] ?? '';
                      final extra = state.extra as Map<String, dynamic>? ?? {};

                      return CustomTransitionPage(
                        transitionDuration: const Duration(milliseconds: 600),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: DetailScreen(
                          reportNumber: reportNumber,
                          classification: extra['classification'] ?? '',
                          location: extra['location'] ?? '',
                          status: extra['status'] ?? '',
                          date: extra['date'] ?? '',
                          username: extra['username'] ?? '',
                          description: extra['description'] ?? '',
                          extra: extra,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Search
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

          // Report
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.reportPage,
                name: 'report',
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>? ?? {};
                  return MaterialPage(
                    child: ReportScreen(
                      imagePath: extra['imagePath'] as String?,
                      detections: (extra['detections'] as List<dynamic>?)
                          ?.map((e) => Map<String, dynamic>.from(e))
                          .toList(),
                      outputImage: extra['outputImage'] as Uint8List?,
                      location: extra['location'] as Position?,
                      address: extra['address'] as String?,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: Routes.cameraPage, // this is 'camera'
                    name: 'camera',
                    pageBuilder: (context, state) =>
                        const MaterialPage(child: CameraScreen()),
                  ),
                ],
              ),
            ],
          ),

          // Notifications
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

          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profilePage,
                name: 'profile',
                pageBuilder: (context, state) =>
                    const MaterialPage(child: ProfileScreen()),
                routes: [
                  GoRoute(
                    path: Routes.settingsPage,
                    name: 'profileSettings',
                    pageBuilder: (context, state) =>
                        const MaterialPage(child: SettingsScreen()),
                  ),
                  // For profile rating
                  GoRoute(
                    path: '/profile/rating/:reportNumber',
                    name: 'profileRating',
                    pageBuilder: (context, state) {
                      final reportNumber =
                          state.pathParameters['reportNumber'] ?? '';
                      final extra = state.extra as Map<String, dynamic>? ?? {};

                      return CustomTransitionPage(
                        transitionDuration: const Duration(milliseconds: 600),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: RatingScreen(
                          reportNumber: reportNumber,
                          classification: extra['classification'] ?? '',
                          location: extra['location'] ?? '',
                          status: extra['status'] ?? '',
                          date: extra['date'] ?? '',
                          username: extra['username'] ?? '',
                          description: extra['description'] ?? '',
                          image: extra['image'] ?? '',
                          extra: extra,
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