import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../auth_gate.dart';

class SettingsScreen extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const SettingsScreen({super.key, required this.googleSignIn});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await AuthGate.logout(context, widget.googleSignIn);
      if (mounted) {
        // Use goNamed to ensure proper navigation stack reset
        context.goNamed('login');
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to completely sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outlined),
            title: const Text('Account Security'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber_outlined),
            title: const Text('Privacy & Policies'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {},
          ),
          const Divider(height: 20),
          ListTile(
            leading: _isLoggingOut
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout, color: Colors.red),
            title: Text(
              _isLoggingOut ? 'Signing out...' : 'Sign Out',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }
}