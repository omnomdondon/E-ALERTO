import 'dart:convert';
import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:e_alerto/controller/routes.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String phone;
  final String username;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.phone,
    required this.username,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String otpCode = '';
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  Future<void> _sendOTP() async {
    await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.email, 'phone': widget.phone}),
    );
  }

  Future<void> _verifyOTP() async {
    if (otpCode.length != 6) return;

    setState(() => isVerifying = true);

    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.email, 'otp': otpCode}),
    );

    setState(() => isVerifying = false);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 64.sp),
                SizedBox(height: 20.h),
                Text('Welcome aboard!',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                Text(
                  '@${widget.username}, your account has been successfully verified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 25.h),
                ElevatedButton(
                  onPressed: () => context.go(Routes.homePage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                  ),
                  child: Text('Continue',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 44.h, // 🧼 shorter height
      textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: COLOR_PRIMARY, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logos/E-ALERTO_Logo_Colored.png',
                  height: 60.h,
                ),
                SizedBox(height: 20.h),
                Text("Verify Your Email",
                    style: TextStyle(
                        fontSize: 22.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                Text(
                  "We've sent a verification code to\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
                SizedBox(height: 30.h),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 200),
                  onChanged: (value) => otpCode = value,
                  onCompleted: (value) => _verifyOTP(),
                ),
                SizedBox(height: 30.h),
                isVerifying
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: COLOR_PRIMARY,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Verify Email",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: _sendOTP,
                  child: const Text("Didn't receive code? Resend",
                      style: TextStyle(color: COLOR_DEFAULT)),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Use a different email",
                      style: TextStyle(color: COLOR_DEFAULT)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
