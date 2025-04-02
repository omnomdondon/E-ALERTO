import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthGate(
        googleSignIn: GoogleSignIn(),
      ),
    );
  }
}
