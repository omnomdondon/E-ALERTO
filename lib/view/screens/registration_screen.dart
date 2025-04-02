import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';
import '../../controller/input_controller.dart';

class RegistrationScreen extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const RegistrationScreen({super.key, required this.googleSignIn});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _inputController = InputController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _registerWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) context.go('/${Routes.homePage.substring(1)}');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
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
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          child: Align(
            alignment: Alignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage(
                              'assets/images/logos/E-ALERTO_Logo_Colored.png'),
                          width: 220,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        const Text(
                          "Let's get started!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        const Text("Email",
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
                          hintText: 'Enter Email',
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          validator: (value) =>
                              _inputController.emailValidator(value),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        const Text("Username",
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
                          hintText: 'Enter username',
                          controller: _usernameController,
                          validator: (value) => _inputController.validator(
                              value, "Username is required"),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        const Text("Password",
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
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
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) =>
                              _inputController.passwordValidator(value),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        const Text("Confirm Password",
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
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
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) => _inputController.confirmPass(
                              value, _passwordController.text),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Container(
                          alignment: Alignment.center,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: COLOR_PRIMARY,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  CustomFilledButton(
                                    text: 'Register',
                                    onPressed: _registerWithEmailAndPassword,
                                    fullWidth: true,
                                  ),
                                  const SizedBox(height: 15),
                                  const Center(
                                    child: Text('OR',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                  const SizedBox(height: 15),
                                  CustomFilledButton(
                                    text: 'Sign up with Google',
                                    onPressed: _signInWithGoogle,
                                    fullWidth: true,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black87,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/icons/google_icon.png',
                                          height: 24,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text('Sign up with Google'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account? '),
                              GestureDetector(
                                onTap: () => context.go(Routes.loginPage),
                                child: Text(
                                  'Login here',
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
      ),
    );
  }
}