import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/auth_service.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../widgets/custom_filledbutton.dart';
import '../widgets/custom_google_button.dart';
import '../widgets/custom_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

int _loginAttempts = 0;
DateTime? _lockUntil;

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();

    // Check lock status
    if (_lockUntil != null && DateTime.now().isBefore(_lockUntil!)) {
      final secondsLeft = _lockUntil!.difference(DateTime.now()).inSeconds;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Too many failed attempts. Try again in $secondsLeft seconds."),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        // 🧼 Reset attempts on successful login
        _loginAttempts = 0;
        _lockUntil = null;
        prefs.remove('loginAttempts');
        prefs.remove('lockUntil');
        context.goNamed('home');
      } else {
        _loginAttempts++;
        await prefs.setInt('loginAttempts', _loginAttempts);

        if (_loginAttempts >= 3) {
          _lockUntil = DateTime.now().add(const Duration(seconds: 10));
          await prefs.setInt('lockUntil', _lockUntil!.millisecondsSinceEpoch);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Too many attempts. You're locked for 1 minute.")),
          );
        } else {
          final remaining = 3 - _loginAttempts;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Login failed. $remaining attempt(s) left.")),
          );
        }
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
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

  @override
  void initState() {
    super.initState();
    _loadLockStatus();
  }

  Future<void> _loadLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _loginAttempts = prefs.getInt('loginAttempts') ?? 0;
    final lockTimestamp = prefs.getInt('lockUntil');

    if (lockTimestamp != null) {
      _lockUntil = DateTime.fromMillisecondsSinceEpoch(lockTimestamp);
      if (_lockUntil!.isBefore(DateTime.now())) {
        // Lock expired, reset
        _loginAttempts = 0;
        _lockUntil = null;
        prefs.remove('loginAttempts');
        prefs.remove('lockUntil');
      }
    }
  }
}
