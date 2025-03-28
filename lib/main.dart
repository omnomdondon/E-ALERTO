import 'package:e_alerto/controller/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return MaterialApp.router(
              routerConfig: router,
              color: Colors.white,
              theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
              debugShowCheckedModeBanner: false,
              title: 'Rawr',
            );
          },
        );
      },
    );
  }
}

// import 'package:e_alerto/controller/router.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';


// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       builder: (_, child) {
//         return MaterialApp.router (
//           routerConfig: router,
//           color: Colors.white,
//           theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
//           debugShowCheckedModeBanner: false,
//           title: 'Rawr',
//         );
//       },
//     );
//   }
// }
