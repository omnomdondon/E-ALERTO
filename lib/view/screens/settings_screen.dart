import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Container(
          width: 5,
          decoration: BoxDecoration(
            color: COLOR_PRIMARY, // Background color
            shape: BoxShape.circle, // Makes it circular
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // Icon color
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: ListView(
      children: [
          ListTile(
            leading: Icon(Icons.lock_outlined),
            title: Text('Account Security'),
            onTap: () {
              // Navigate to Profile Settings page
            },
          ),

          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notification Settings'),
            onTap: () {
              // Navigate to Notification Settings page
            },
          ),

          ListTile(
            leading: Icon(Icons.warning_amber_outlined),
            title: Text('Privacy & Policies'),
            onTap: () {
              // Navigate to Privacy & Security page
            },
          ),

          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              // Navigate to Privacy & Security page
            },
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () => GoRouter.of(context).go(Routes.loginPage)
          ),
        ],
    ),
  );
}