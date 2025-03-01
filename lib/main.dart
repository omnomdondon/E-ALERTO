import 'package:e_alerto/controller/router.dart';
import 'package:e_alerto/view/layout_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view/screens/login_screen.dart';
import 'view/screens/registration_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp.router (
          routerConfig: router,
          color: Colors.white,
          theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
          debugShowCheckedModeBanner: false,
          title: 'Rawr',
        );
      },
    );
  }
}
