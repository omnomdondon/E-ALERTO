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

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  redirect: (BuildContext context, GoRouterState state) async {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/auth' || 
                        state.matchedLocation == Routes.loginPage || 
                        state.matchedLocation == Routes.registrationPage;

    // If user is not logged in and trying to access protected route
    if (!isLoggedIn && !isAuthRoute) {
      return '/auth';
    }

    // If user is logged in and trying to access auth route
    if (isLoggedIn && isAuthRoute) {
      return Routes.homePage;
    }

    return null;
  },
  routes: [
    // Auth routes
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => const MaterialPage<void>(
        child: AuthGate(),
      ),
      routes: [
        GoRoute(
          path: Routes.loginPage.substring(1), // 'login'
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: LoginScreen(),
          ),
        ),
        GoRoute(
          path: Routes.registrationPage.substring(1), // 'registration'
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: RegistrationScreen(),
          ),
        ),
      ],
    ),

    // Main app shell
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        // Home Branch
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.homePage,
              pageBuilder: (context, state) => const MaterialPage<void>(
                child: HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: Routes.detailPage,
                  pageBuilder: (context, state) => MaterialPage<void>(
                    child: DetailScreen(
                      reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
                      classification: state.uri.queryParameters['classification'] ?? '',
                      location: state.uri.queryParameters['location'] ?? '',
                      status: state.uri.queryParameters['status'] ?? '',
                      date: state.uri.queryParameters['date'] ?? '',
                      username: state.uri.queryParameters['username'] ?? '',
                      description: state.uri.queryParameters['description'] ?? '',
                      extra: state.extra as Map<String, dynamic>? ?? {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Search Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.searchPage,
              pageBuilder: (context, state) => const MaterialPage<void>(
                child: SearchScreen(),
              ),
            ),
          ],
        ),
        
        // Report Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.reportPage,
              pageBuilder: (context, state) => MaterialPage<void>(
                child: ReportScreen(),
              ),
            ),
          ],
        ),
        
        // Notification Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.notificationPage,
              pageBuilder: (context, state) => MaterialPage<void>(
                child: NotificationScreen(),
              ),
            ),
          ],
        ),
        
        // Profile Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profilePage,
              pageBuilder: (context, state) => const MaterialPage<void>(
                child: ProfileScreen(),
              ),
              routes: [
                GoRoute(
                  path: Routes.settingsPage,
                  pageBuilder: (context, state) => const MaterialPage<void>(
                    child: SettingsScreen(),
                  ),
                ),
                GoRoute(
                  path: Routes.ratingPage,
                  pageBuilder: (context, state) => MaterialPage<void>(
                    child: RatingScreen(
                      reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
                      classification: state.uri.queryParameters['classification'] ?? '',
                      location: state.uri.queryParameters['location'] ?? '',
                      status: state.uri.queryParameters['status'] ?? '',
                      date: state.uri.queryParameters['date'] ?? '',
                      username: state.uri.queryParameters['username'] ?? '',
                      description: state.uri.queryParameters['description'] ?? '',
                      image: (state.extra as Map<String, dynamic>?)?['image'] ?? '',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// import 'package:e_alerto/controller/routes.dart';
// import 'package:e_alerto/view/layout_scaffold.dart';
// import 'package:e_alerto/view/screens/detail_screen.dart';
// import 'package:e_alerto/view/screens/home_screen.dart';
// import 'package:e_alerto/view/screens/login_screen.dart';
// import 'package:e_alerto/view/screens/notification_screen.dart';
// import 'package:e_alerto/view/screens/profile_screen.dart';
// import 'package:e_alerto/view/screens/rating_screen.dart';
// import 'package:e_alerto/view/screens/registration_screen.dart';
// import 'package:e_alerto/view/screens/report_screen.dart';
// import 'package:e_alerto/view/screens/search_screen.dart';
// import 'package:e_alerto/view/screens/settings_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// final router = GoRouter(
//   navigatorKey: _rootNavigatorKey,
//   initialLocation: Routes.loginPage,
//   routes: [
//     GoRoute(
//       path: Routes.loginPage,
//       builder: (context, state) => LoginScreen(),
//     ),
//     GoRoute(
//       path: Routes.registrationPage,
//       builder: (context, state) => RegistrationScreen(),
//     ),


//     StatefulShellRoute.indexedStack(
//       builder: (context, state, navigationShell) => LayoutScaffold(
//         navigationShell: navigationShell,
//       ),
//       branches: [
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: Routes.homePage,
//               builder: (context, state) => const HomeScreen(),
//               routes: [
//                 GoRoute(
//                   path: Routes.detailPage, // Ensure this has a parameter
//                   builder: (context, state) {
//                     return DetailScreen(
//                       reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
//                       classification: state.uri.queryParameters['classification'] ?? '',
//                       location: state.uri.queryParameters['location'] ?? '',
//                       status: state.uri.queryParameters['status'] ?? '',
//                       date: state.uri.queryParameters['date'] ?? '',
//                       username: state.uri.queryParameters['username'] ?? '',
//                       description: state.uri.queryParameters['description'] ?? '',
//                       //image: state.uri.queryParameters['image'] ?? '', extra: {},
//                       extra: state.extra as Map<String, dynamic>? ?? {},
//                     );
//                   },
//                 ),
//               ]
//             )
//           ]
//         ),
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: Routes.searchPage,
//               builder: (context, state) => const SearchScreen(),
//             )
//           ]
//         ),
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: Routes.reportPage,
//               builder: (context, state) => ReportScreen(),
//             )
//           ]
//         ),
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: Routes.notificationPage,
//               builder: (context, state) => NotificationScreen(), // replace diz
//             )
//           ]
//         ),
//         StatefulShellBranch(
//           routes: [
//             GoRoute(
//               path: Routes.profilePage,
//               builder: (context, state) => const ProfileScreen(),
//               routes: [
//                 GoRoute(
//                   path: Routes.settingsPage,
//                   builder: (context, state) => const SettingsScreen(),
//                 ),
//                 GoRoute(
//                   path: Routes.ratingPage,
//                   builder: (context, state) {
//                     final extra = state.extra as Map<String, dynamic>? ?? {};
//                     return RatingScreen(
//                       reportNumber: state.uri.queryParameters['reportNumber'] ?? '',
//                       classification: state.uri.queryParameters['classification'] ?? '',
//                       location: state.uri.queryParameters['location'] ?? '',
//                       status: state.uri.queryParameters['status'] ?? '',
//                       date: state.uri.queryParameters['date'] ?? '',
//                       username: state.uri.queryParameters['username'] ?? '',
//                       description: state.uri.queryParameters['description'] ?? '',
//                       image: extra['image'] ?? '', // ✅ Extract from `extra`
//                     );
//                   },
//                 ),
//               ]
//             )
//           ]
//         )
//       ]
//     ),
//   ],
// );
