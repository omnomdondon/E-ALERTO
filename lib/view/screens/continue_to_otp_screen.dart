import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueToOTPScreen extends StatelessWidget {
  final String email;
  final String phone;
  final String username;

  const ContinueToOTPScreen({
    super.key,
    required this.email,
    required this.phone,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 50.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 100, color: COLOR_PRIMARY),
            SizedBox(height: 30.h),
            Text(
              'Registration Successful!',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'To access full features, please verify your account via OTP. You can skip for now and log in as unverified.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('otp', extra: {
                  'email': email,
                  'phone': phone,
                  'username': username,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: COLOR_PRIMARY,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              ),
              child: Text('Continue to OTP',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            ),
            TextButton(
              onPressed: () => context.go(Routes.loginPage),
              child: const Text(
                'Skip for now and Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
