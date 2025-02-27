import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
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
                          CustomTextFormField(hintText: 'Enter Email'),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text("Username", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(hintText: 'Enter username'),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text("Password", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(
                            hintText: 'Enter Password',
                            isVisible: true,
                            trailing: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          const Text("Confirm Password", style: TextStyle(color: Colors.black54)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomTextFormField(
                            hintText: 'Enter Password',
                            isVisible: true,
                            trailing: const Icon(Icons.visibility_off_outlined, color: Colors.grey),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Container(
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "By registering, you agree with the ",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Privacy and Policies",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            child: RichText(
                              text: TextSpan(
                                text: "No account yet? ",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Register here",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: COLOR_PRIMARY,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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