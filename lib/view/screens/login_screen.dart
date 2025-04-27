import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/auth_service.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_filledbutton.dart';
import '../widgets/custom_google_button.dart';
import '../widgets/custom_textformfield.dart';

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
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login failed. Please check credentials.')),
        );
      }
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);

    final success = await AuthService.googleLogin();

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed.')),
        );
      }
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: 30.h,
              horizontal: 25.w,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                        'assets/images/logos/E-ALERTO_Logo_Colored.png'),
                    width: 240,
                  ),
                  SizedBox(height: 30.h),
                  CustomTextFormField(
                    label: 'Email',
                    hintText: 'Enter Email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your email';
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  CustomTextFormField(
                    label: 'Password',
                    hintText: 'Enter Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your password';
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CustomFilledButton(
                          text: 'Login',
                          onPressed: _login,
                          fullWidth: true,
                        ),
                  SizedBox(height: 20.h),
                  const Text('or'),
                  SizedBox(height: 20.h),
                  CustomGoogleButton(
                    text: 'Sign In with Google',
                    onPressed: _googleSignIn,
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No account yet? '),
                      GestureDetector(
                        onTap: () => context.go(Routes.registrationPage),
                        child: Text(
                          'Register here',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: COLOR_PRIMARY,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// // login_screen.dart (Firebase-stripped)
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import '../../controller/routes.dart';
// import '../widgets/custom_filledbutton.dart';
// import '../widgets/custom_textformfield.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     // TODO: Replace with MongoDB auth logic
//     await Future.delayed(const Duration(seconds: 1));

//     if (mounted) {
//       context.goNamed('home');
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: ScreenUtil().screenHeight,
//           width: ScreenUtil().screenWidth,
//           color: Colors.white,
//           alignment: Alignment.center,
//           child: ListView(
//             shrinkWrap: true,
//             padding: EdgeInsets.symmetric(
//               vertical: ScreenUtil().setWidth(50),
//               horizontal: ScreenUtil().setWidth(25),
//             ),
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Image(
//                       image: AssetImage(
//                           'assets/images/logos/E-ALERTO_Logo_Colored.png'),
//                       width: 240,
//                     ),
//                     SizedBox(height: ScreenUtil().setHeight(30)),
//                     CustomTextFormField(
//                       controller: _emailController,
//                       label: 'Email',
//                       hintText: 'Enter Email',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: ScreenUtil().setHeight(15)),
//                     CustomTextFormField(
//                       controller: _passwordController,
//                       label: 'Password',
//                       hintText: 'Enter Password',
//                       obscureText: _obscurePassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 30),
//                     _isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : CustomFilledButton(
//                             text: 'Login',
//                             onPressed: _login,
//                             fullWidth: true,
//                           ),
//                     const SizedBox(height: 30),
//                     Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('No account yet? '),
//                           GestureDetector(
//                             onTap: () => context.go(Routes.registrationPage),
//                             child: Text(
//                               'Register here',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium
//                                   ?.copyWith(
//                                     color: Colors.blue,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
