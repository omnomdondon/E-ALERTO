import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';

class LoginScreen extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const LoginScreen({super.key, required this.googleSignIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) context.go('/${Routes.homePage.substring(1)}');
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
      final GoogleSignInAccount? googleUser =
          await widget.googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        context.go(Routes.homePage);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Sign-In Error: ${e.code} - ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sign-In failed: ${e.message ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during Google sign in: $e')),
        );
      }
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
                        image: AssetImage(
                            'assets/images/logos/E-ALERTO_Logo_Colored.png'),
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
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black87),
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
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(height: 15),
                      CustomFilledButton(
                        text: 'Sign in with Google',
                        onPressed: _signInWithGoogle,
                        fullWidth: true,
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icons/google_icon.png',
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            const Text('Sign in with Google'),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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