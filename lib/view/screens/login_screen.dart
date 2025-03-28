import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Ensure this import is present

import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation is handled by AuthGate and router redirect
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigation is handled by AuthGate and router redirect
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google sign in failed')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(50),
                horizontal: ScreenUtil().setWidth(25),
              ),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/logos/E-ALERTO_Logo_Colored.png'),
                        width: 240,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      const Text(
                        "Hello, welcome!", 
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)), 
                      const Text(
                        "Email", 
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      const Text(
                        "Password", 
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter Password',
                        isVisible: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            "Forgot password?", 
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomFilledButton(
                              text: 'Login',
                              onPressed: _signInWithEmailAndPassword,
                              fullWidth: true,
                            ),
                      const SizedBox(height: 15),
                      const Center(
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: _signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No account yet? '),
                            GestureDetector(
                              onTap: () => context.go(Routes.registrationPage),
                              child: Text(
                                'Register here',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: COLOR_PRIMARY,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),                          
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/controller/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// import '../widgets/custom_textformfield.dart';
// import '../widgets/custom_filledbutton.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LogInScreenState();
// }

// class _LogInScreenState extends State<LoginScreen> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container( 
//           color: Colors.white,
//           height: ScreenUtil().screenHeight,
//           width: ScreenUtil().screenWidth,
//           child: Center(
//             child: ListView(
//               shrinkWrap: true,
//               padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(50), horizontal: ScreenUtil().setWidth(25)),
//               children: [
//                 Form( // ✅ Keeping Form widget for login
//                   child: 
//                     Column( // ✅ Wrapping multiple widgets inside a Column
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Image(
//                           image: AssetImage('assets/images/logos/E-ALERTO_Logo_Colored.png'),
//                           width: 240,
//                         ),
//                         SizedBox(height: ScreenUtil().setHeight(10)),
//                         const Text(
//                           "Hello, welcome!", 
//                           style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold
//                           )
//                         ),
//                         SizedBox(height: ScreenUtil().setHeight(30)), 
//                         const Text(
//                           "Username", 
//                           style: TextStyle(color: Colors.black54)
//                         ),
//                         SizedBox(height: ScreenUtil().setHeight(10)), // ✅ Now correctly placed inside Column
//                         CustomTextFormField(
//                           label: 'Username',
//                           hintText: 'Enter Username',
//                         ),
//                         SizedBox(height: ScreenUtil().setHeight(15)),
//                         const Text(
//                           "Password", 
//                           style: TextStyle(color: Colors.black54)
//                         ),
//                         SizedBox(height: ScreenUtil().setHeight(10)),
//                         CustomTextFormField(
//                           label: 'Password',
//                           hintText: 'Enter Password',
//                           isVisible: true, // Hide password input
//                           /*trailing: const Icon(
//                               Icons.visibility_off_outlined,
//                               color: Colors.grey,
//                             ),*/
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//                           child: 
//                             TextButton(
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                 overlayColor: WidgetStateProperty.all(Colors.transparent),
//                               ),
//                               child: 
//                                 const Text(
//                                   "Forgot password?", 
//                                   style: TextStyle(
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                             ),
//                         ),
//                         SizedBox(height: 30), // Add spacing before button
//                         CustomFilledButton(
//                           text: 'Login', 
//                           onPressed: () => GoRouter.of(context).go('/home'),
//                           fullWidth: true,
//                         ),
//                         SizedBox(height: 30),
//                         Container(
//                           alignment: Alignment.center,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text('No account yet? ',
//                               ),
//                               GestureDetector(
//                                 onTap: () => GoRouter.of(context).go(Routes.registrationPage),
//                                 child: Text(
//                                   'Register here',
//                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     color: COLOR_PRIMARY,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         )
//                       ],
//                     ),
//                 ),                          
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     throw UnimplementedError();
//   }
  
// }