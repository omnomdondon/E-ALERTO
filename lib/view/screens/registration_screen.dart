import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _registerWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation is handled by AuthGate and router redirect
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
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
                          image: AssetImage('assets/images/logos/E-ALERTO_Logo_Colored.png'),
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
                          validator: (value) => _inputController.validator(value, "Username is required"),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        const Text("Password", style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
                          hintText: 'Enter Password',
                          controller: _passwordController,
                          isVisible: true,
                          validator: (value) => _inputController.passwordValidator(value),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        const Text("Confirm Password", style: TextStyle(color: Colors.black54)),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        CustomTextFormField(
                          hintText: 'Confirm Password',
                          controller: _confirmPasswordController,
                          isVisible: !_inputController.isVisible,
                          trailing: IconButton(
                            onPressed: () => _inputController.showHidePassword(),
                            icon: Icon(
                              !_inputController.isVisible 
                                ? Icons.visibility_off_outlined 
                                : Icons.visibility, 
                              color: Colors.grey,
                            ),
                          ),
                          validator: (value) => _inputController.confirmPass(value, _passwordController.text),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Container(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By registering, you agree with the ",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Privacy and Policies",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                onPressed: _registerWithEmailAndPassword,
                                fullWidth: true,
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
// import '../../controller/input_controller.dart';
// import '../../controller/registration_controller.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final email = TextEditingController();
//   final username = TextEditingController();
//   final password = TextEditingController();
//   final confirmPassword = TextEditingController();

//   final inputController = InputController();
//   final formKey = GlobalKey<FormState>();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           color: Colors.white,
//           height: ScreenUtil().screenHeight,
//           width: ScreenUtil().screenWidth,
//           child:
//             Align(
//               alignment: Alignment.center,
//               child: Center( // ✅ Ensures contents are centered
//                 child: ListView(
//                   shrinkWrap: true, // ✅ Makes ListView take only as much space as needed
//                   padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(50), horizontal: ScreenUtil().setWidth(25)),
//                   children: [
//                     Form(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center, // ✅ Center items
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Image(
//                             image: AssetImage('assets/images/logos/E-ALERTO_Logo_Colored.png'),
//                             width: 220,
//                           ),
//                           SizedBox(height: ScreenUtil().setHeight(10)),
//                           const Text(
//                             "Let's get started!", 
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold
//                             )
//                           ),
//                           SizedBox(height: ScreenUtil().setHeight(30)), 
//                           const Text("Email", style: TextStyle(color: Colors.black54)),
//                           SizedBox(height: ScreenUtil().setHeight(10)),
//                           CustomTextFormField(
//                             hintText: 'Enter Email',
//                             controller: email,
//                             inputType: TextInputType.emailAddress,
//                             validator: (value)=> inputController.emailValidator(value)),

//                           SizedBox(height: ScreenUtil().setHeight(15)),
//                           const Text("Username", style: TextStyle(color: Colors.black54)),
//                           SizedBox(height: ScreenUtil().setHeight(10)),
//                           CustomTextFormField(
//                             hintText: 'Enter username',
//                             controller: username,
//                             validator: (value) => inputController.validator(value, "Username is required"),),
//                           SizedBox(height: ScreenUtil().setHeight(15)),
//                           const Text("Password", style: TextStyle(color: Colors.black54)),
//                           SizedBox(height: ScreenUtil().setHeight(10)),
                          
//                           CustomTextFormField(
//                             hintText: 'Enter Password',
//                             controller: password,
//                             isVisible: true,
                            
//                             validator: (value)=> inputController.passwordValidator(value)
//                           ),
//                           SizedBox(height: ScreenUtil().setHeight(15)),

//                           const Text("Confirm Password", style: TextStyle(color: Colors.black54)),
//                           SizedBox(height: ScreenUtil().setHeight(10)),
//                           CustomTextFormField(
//                             hintText: 'Enter Password',
//                             controller: confirmPassword,
//                             isVisible: !inputController.isVisible,
//                             trailing: IconButton(
//                               onPressed: ()=> inputController.showHidePassword(),
//                               icon: Icon(!inputController.isVisible? Icons.visibility_off_outlined : Icons.visibility, color: Colors.grey),
//                             ),
//                             validator: (value)=> inputController.confirmPass(value,password.text)
//                           ),
//                           SizedBox(height: ScreenUtil().setHeight(20)),
//                           Container(
//                             alignment: Alignment.center,
//                             child: RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                 text: "By registering, you agree with the ",
//                                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
//                                 children: [
//                                   TextSpan(
//                                     text: "Privacy and Policies",
//                                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                       color: COLOR_PRIMARY,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ),
//                           SizedBox(height: 30),
//                           CustomFilledButton(
//                             text: 'Register',
//                             onPressed: () {},
//                             fullWidth: true,
//                           ),
//                           SizedBox(height: 30),
//                           Container(
//                             alignment: Alignment.center,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text('Already have an account? ',
//                                 ),
//                                 GestureDetector(
//                                   onTap: () => GoRouter.of(context).go(Routes.loginPage),
//                                   child: Text(
//                                     'Login here',
//                                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                       color: COLOR_PRIMARY,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             )
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//             ),
//           ),
//         ),
//       ),
//     );

//     throw UnimplementedError();
//   }
  
// }