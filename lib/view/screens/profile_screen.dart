import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.white, surfaceTintColor: Colors.white),
    backgroundColor: Colors.white,
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profile Page UwU')
        ],
      ),
    ),
  );
}