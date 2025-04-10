import 'package:e_alerto/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const AuthGate({super.key, required this.googleSignIn});

  @override
  State<AuthGate> createState() => _AuthGateState();

  static Future<void> logout(
      BuildContext context, GoogleSignIn googleSignIn) async {
    try {
      // Sign out from both services with proper error handling
      await Future.wait([
        googleSignIn.signOut().catchError((e) {
          debugPrint('Google sign out error: $e');
        }),
        FirebaseAuth.instance.signOut(),
      ]);

      // Clear any cached credentials
      await googleSignIn.disconnect().catchError((e) {
        debugPrint('Google disconnect error: $e');
      });

      // Ensure complete sign out
      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        // Navigate to login screen
        final router = GoRouter.of(context);
        router.goNamed('login');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      rethrow;
    }
  }
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        final currentRoute = GoRouterState.of(context).uri.path;

        debugPrint(
            'AuthGate - Current route: $currentRoute, User: ${user?.uid}');

        // User is not signed in
        if (user == null) {
          if (!currentRoute.startsWith(Routes.auth)) {
            Future.microtask(() {
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.goNamed('login');
              }
            });
          }
          return LoginScreen(googleSignIn: widget.googleSignIn);
        }

        // User is signed in but on auth route - redirect to home
        if (currentRoute.startsWith(Routes.auth)) {
          Future.microtask(() {
            // ignore: use_build_context_synchronously
            if (mounted) context.goNamed('home');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}