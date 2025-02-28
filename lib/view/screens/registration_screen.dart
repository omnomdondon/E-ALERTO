import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';
import '../../controller/input_controller.dart';
import '../../controller/registration_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final inputController = InputController();
  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child:
            Align(
              alignment: Alignment.center,
              child: Center( // ✅ Ensures contents are centered
                child: ListView(
                  shrinkWrap: true, // ✅ Makes ListView take only as much space as needed
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(50), horizontal: ScreenUtil().setWidth(25)),
                  children: [
                    Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // ✅ Center items
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Image(
                            image: AssetImage('../../../assets/images/logos/E-ALERTO_Logo_Colored.png'),
                            width: 267,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text(
                            "Let's get started!", 
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40)), 
                          const Text("Email", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(
                            hintText: 'Enter Email',
                            controller: email,
                            inputType: TextInputType.emailAddress,
                            validator: (value)=> inputController.emailValidator(value)),

                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text("Username", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(
                            hintText: 'Enter username',
                            controller: username,
                            validator: (value) => inputController.validator(value, "Username is required"),),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text("Password", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          
                          CustomTextFormField(
                            hintText: 'Enter Password',
                            controller: password,
                            isVisible: true,
                            
                            validator: (value)=> inputController.passwordValidator(value)
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),

                          const Text("Confirm Password", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(
                            hintText: 'Enter Password',
                            controller: confirmPassword,
                            isVisible: !inputController.isVisible,
                            trailing: IconButton(
                              onPressed: ()=> inputController.showHidePassword(),
                              icon: Icon(!inputController.isVisible? Icons.visibility_off_outlined : Icons.visibility, color: Colors.grey),
                            ),
                            validator: (value)=> inputController.confirmPass(value,password.text)
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
                            )
                          ),
                          SizedBox(height: 30),
                          CustomFilledButton(
                            text: 'Register',
                            onPressed: () {},
                            fullWidth: true,
                          ),
                          SizedBox(height: 30),
                          Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account? ',
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.popAndPushNamed(
                                    context, '/login'
                                  ),
                                  child: Text(
                                    'Login here',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: COLOR_PRIMARY,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )
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

    throw UnimplementedError();
  }
  
}