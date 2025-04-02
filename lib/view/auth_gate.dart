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

  static logout(BuildContext context, GoogleSignIn googleSignIn) {}
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
          return LoginScreen(googleSignIn: widget.googleSignIn);
        }

        // User is signed in but on auth route - redirect to home
        if (currentRoute.startsWith(Routes.auth)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.go(Routes.homePage);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Let the router handle navigation for other cases
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  static Future<void> logout(
      BuildContext context, GoogleSignIn googleSignIn) async {
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        context.go(Routes.loginPage);
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }
  }
}
