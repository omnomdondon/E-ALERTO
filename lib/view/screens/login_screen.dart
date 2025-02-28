import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_textformfield.dart';
import '../widgets/custom_filledbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form( // ✅ Keeping Form widget for login
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column( // ✅ Wrapping multiple widgets inside a Column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage('../../../assets/images/logos/E-ALERTO_Logo_Colored.png'),
                        width: 267,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      const Text(
                        "Hello, welcome!", 
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)), 
                      const Text(
                        "Username", 
                        style: TextStyle(color: Colors.black54)
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)), // ✅ Now correctly placed inside Column
                      CustomTextFormField(
                        label: 'Username',
                        hintText: 'Enter Username',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      const Text(
                        "Password", 
                        style: TextStyle(color: Colors.black54)
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        label: 'Password',
                        hintText: 'Enter Password',
                        isVisible: true, // Hide password input
                        /*trailing: const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),*/
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: 
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                               overlayColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: 
                              const Text(
                                "Forgot password?", 
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                          ),
                      ),
                      SizedBox(height: 30), // Add spacing before button
                      CustomFilledButton(
                        text: 'Login', 
                        onPressed: () {},
                        fullWidth: true,
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No account yet? ',
                            ),
                            GestureDetector(
                              onTap: () => Navigator.popAndPushNamed(
                                context, '/register'
                              ),
                              child: Text(
                                'Register here',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: COLOR_PRIMARY,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    throw UnimplementedError();
  }
  
}