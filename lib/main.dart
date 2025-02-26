import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 800),
      builder: (_, child) {
        return MaterialApp (
          color: Colors.white,
          theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
          debugShowCheckedModeBanner: false,
          title: 'Rawr',
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}
