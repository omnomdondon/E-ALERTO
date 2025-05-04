import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_google_button.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';
import '../../controller/input_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _inputController = InputController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;
  String? _confirmPasswordError;

  // Format: 0912 345 6789
  final _phoneFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    if (digits.length >= 4) {
      formatted += digits.substring(0, 4);
      if (digits.length >= 7) {
        formatted += ' ${digits.substring(4, 7)}';
        if (digits.length >= 11) {
          formatted += ' ${digits.substring(7, 11)}';
        } else if (digits.length > 7) {
          formatted += ' ${digits.substring(7)}';
        }
      } else if (digits.length > 4) {
        formatted += ' ${digits.substring(4)}';
      }
    } else {
      formatted = digits;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  });

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final rawPhone = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    final success = await AuthService.register(
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text.trim(),
      _fullNameController.text.trim(),
      rawPhone,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.goNamed('continueOtp', extra: {
          'email': _emailController.text.trim(),
          'phone': rawPhone,
          'username': _usernameController.text.trim(),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  Future<void> _googleSignUp() async {
    setState(() => _isLoading = true);
    final success = await AuthService.googleLogin();

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-Up failed.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handlePaste(BuildContext context, String field) {
    if (field == "password") {
      setState(() => _passwordError = "Pasting into password is not allowed.");
    } else if (field == "confirm") {
      setState(() => _confirmPasswordError =
          "Pasting into confirm password is not allowed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 25.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage(
                      'assets/images/logos/E-ALERTO_Logo_Colored.png'),
                  width: 220,
                ),
                SizedBox(height: 20.h),
                const Text(
                  "Let's get started!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  label: 'Full Name',
                  hintText: 'Enter Full Name',
                  controller: _fullNameController,
                  validator: (value) => _inputController.validator(
                      value ?? '', "Full name is required"),
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  label: 'Email',
                  hintText: 'Enter Email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (value) =>
                      _inputController.emailValidator(value ?? ''),
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  label: 'Username',
                  hintText: 'Enter Username',
                  controller: _usernameController,
                  validator: (value) => _inputController.validator(
                      value ?? '', "Username is required"),
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  label: 'Phone Number',
                  hintText: 'Enter Phone Number',
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  inputFormatters: [_phoneFormatter],
                  validator: (value) => _inputController.validator(
                      value ?? '', "Phone number is required"),
                ),
                SizedBox(height: 15.h),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) setState(() => _passwordError = null);
                  },
                  child: CustomTextFormField(
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
                      if (_passwordError != null) return _passwordError;
                      return _inputController.passwordValidator(value ?? '');
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) setState(() => _confirmPasswordError = null);
                  },
                  child: CustomTextFormField(
                    label: 'Confirm Password',
                    hintText: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    validator: (value) {
                      if (_confirmPasswordError != null) {
                        return _confirmPasswordError;
                      }
                      return _inputController.confirmPass(
                          value ?? '', _passwordController.text);
                    },
                  ),
                ),
                SizedBox(height: 25.h),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By registering, you agree with the ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Privacy and Policies",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: COLOR_PRIMARY,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomFilledButton(
                        text: 'Register',
                        onPressed: _register,
                        fullWidth: true,
                      ),
                SizedBox(height: 20.h),
                const Text('or', textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                CustomGoogleButton(
                  text: 'Sign Up with Google',
                  onPressed: _googleSignUp,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () => context.go(Routes.loginPage),
                        child: Text(
                          'Login here',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        ),
      ),
    );
  }
}

// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/controller/routes.dart';
// import 'package:e_alerto/controller/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import '../widgets/custom_google_button.dart';
// import '../widgets/custom_textformfield.dart';
// import '../widgets/custom_filledbutton.dart';
// import '../../controller/input_controller.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _fullNameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _inputController = InputController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _passwordError;
//   String? _confirmPasswordError;

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     final success = await AuthService.register(
//       _emailController.text.trim(),
//       _usernameController.text.trim(),
//       _passwordController.text.trim(),
//       _fullNameController.text.trim(),
//     );

//     if (mounted) {
//       setState(() => _isLoading = false);
//       if (success) {
//         context.goNamed('home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registration failed')),
//         );
//       }
//     }
//     print("📨 Submitting registration for ${_emailController.text}");
//   }

//   Future<void> _googleSignUp() async {
//     setState(() => _isLoading = true);

//     final success = await AuthService.googleLogin();

//     if (mounted) {
//       setState(() => _isLoading = false);
//       if (success) {
//         context.goNamed('home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Google Sign-Up failed.')),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _usernameController.dispose();
//     _fullNameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _handlePaste(BuildContext context, String field) {
//     if (field == "password") {
//       setState(() => _passwordError = "Pasting into password is not allowed.");
//     } else if (field == "confirm") {
//       setState(() => _confirmPasswordError =
//           "Pasting into confirm password is not allowed.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             vertical: 30.h,
//             horizontal: 25.w,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Image(
//                   image: AssetImage(
//                       'assets/images/logos/E-ALERTO_Logo_Colored.png'),
//                   width: 220,
//                 ),
//                 SizedBox(height: 20.h),
//                 const Text(
//                   "Let's get started!",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 CustomTextFormField(
//                   label: 'Full Name',
//                   hintText: 'Enter Full Name',
//                   controller: _fullNameController,
//                   validator: (value) => _inputController.validator(
//                       value, "Full name is required"),
//                 ),
//                 SizedBox(height: 15.h),
//                 CustomTextFormField(
//                   label: 'Email',
//                   hintText: 'Enter Email',
//                   controller: _emailController,
//                   inputType: TextInputType.emailAddress,
//                   validator: (value) => _inputController.emailValidator(value),
//                 ),
//                 SizedBox(height: 15.h),
//                 CustomTextFormField(
//                   label: 'Username',
//                   hintText: 'Enter Username',
//                   controller: _usernameController,
//                   validator: (value) =>
//                       _inputController.validator(value, "Username is required"),
//                 ),
//                 SizedBox(height: 15.h),
//                 Focus(
//                   onFocusChange: (hasFocus) {
//                     if (hasFocus) setState(() => _passwordError = null);
//                   },
//                   child: CustomTextFormField(
//                     label: 'Password',
//                     hintText: 'Enter Password',
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () =>
//                           setState(() => _obscurePassword = !_obscurePassword),
//                     ),
//                     validator: (value) {
//                       if (_passwordError != null) return _passwordError;
//                       return _inputController.passwordValidator(value);
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 15.h),
//                 Focus(
//                   onFocusChange: (hasFocus) {
//                     if (hasFocus) setState(() => _confirmPasswordError = null);
//                   },
//                   child: CustomTextFormField(
//                     label: 'Confirm Password',
//                     hintText: 'Confirm Password',
//                     controller: _confirmPasswordController,
//                     obscureText: _obscureConfirmPassword,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirmPassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () => setState(() =>
//                           _obscureConfirmPassword = !_obscureConfirmPassword),
//                     ),
//                     validator: (value) {
//                       if (_confirmPasswordError != null) {
//                         return _confirmPasswordError;
//                       }
//                       return _inputController.confirmPass(
//                           value, _passwordController.text);
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 25.h),
//                 Center(
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       text: "By registering, you agree with the ",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(color: Colors.black),
//                       children: [
//                         TextSpan(
//                           text: "Privacy and Policies",
//                           style:
//                               Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     color: COLOR_PRIMARY,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 25.h),
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomFilledButton(
//                         text: 'Register',
//                         onPressed: _register,
//                         fullWidth: true,
//                       ),
//                 SizedBox(height: 20.h),
//                 const Text('or', textAlign: TextAlign.center),
//                 SizedBox(height: 20.h),
//                 CustomGoogleButton(
//                   text: 'Sign Up with Google',
//                   onPressed: _googleSignUp,
//                 ),
//                 const SizedBox(height: 30),
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Already have an account? '),
//                       GestureDetector(
//                         onTap: () => context.go(Routes.loginPage),
//                         child: Text(
//                           'Login here',
//                           style:
//                               Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     color: COLOR_PRIMARY,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }