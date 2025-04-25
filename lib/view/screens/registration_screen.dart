// registration_screen.dart (Firebase-stripped)
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _inputController = InputController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Replace with MongoDB registration logic
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.goNamed('home');
      setState(() => _isLoading = false);
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
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setWidth(50),
            horizontal: ScreenUtil().setWidth(25),
          ),
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
                SizedBox(height: ScreenUtil().setHeight(10)),
                const Text("Let's get started!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                SizedBox(height: ScreenUtil().setHeight(30)),
                const Text("Email", style: TextStyle(color: Colors.black54)),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  hintText: 'Enter Email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  validator: (value) => _inputController.emailValidator(value),
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
                const Text("Username", style: TextStyle(color: Colors.black54)),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  hintText: 'Enter username',
                  controller: _usernameController,
                  validator: (value) =>
                      _inputController.validator(value, "Username is required"),
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
                const Text("Password", style: TextStyle(color: Colors.black54)),
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
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) => _inputController.confirmPass(
                      value, _passwordController.text),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
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
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomFilledButton(
                        text: 'Register',
                        onPressed: _register,
                        fullWidth: true,
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
