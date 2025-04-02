import 'package:e_alerto/controller/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    rethrow;
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoogleSignIn _googleSignIn;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId:
          '288160619445-p1uvlkkjfg2f8v2e7oa5mb6mbtavos7h.apps.googleusercontent.com',
    );
    _router = createRouter(_googleSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp.router(
          routerConfig: _router,
          color: Colors.white,
          theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
          debugShowCheckedModeBanner: false,
          title: 'E-ALERTO',
        );
      },
    );
  }
}