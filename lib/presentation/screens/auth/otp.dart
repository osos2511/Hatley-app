import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/core/success_dialog.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/routes_manager.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String otp = "";
  int secondsRemaining = 30;
  Timer? _timer;
  bool enableResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: screenSize.height,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.primaryGradientStart, ColorsManager.primaryGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Email Verification',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Enter the 4-digit code sent to\nexample@email.com',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo2(color: ColorsManager.white70, fontSize: 14.sp),
                ),
                SizedBox(height: 40.h),

                PinCodeTextField(
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.r),
                    fieldHeight: 55.h,
                    fieldWidth: 50.w,
                    inactiveColor: ColorsManager.white.withOpacity(0.5),
                    activeColor: ColorsManager.blue,
                    selectedColor: ColorsManager.blue,
                  ),
                  onChanged: (value) {
                    setState(() => otp = value);
                  },
                  appContext: context,
                ),

                SizedBox(height: 25.h),

                Text(
                  enableResend
                      ? "Didn't receive the code? Resend"
                      : "Resend code in $secondsRemaining s",
                  style: TextStyle(
                    color:
                        enableResend ? ColorsManager.blue : ColorsManager.white70,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 40.h),
                CustomButton(
                  bgColor: ColorsManager.white,
                  foColor: ColorsManager.blue,
                  onPressed: () async{
                    if (otp.length == 4) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),);
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context);
                      showSuccessDialog(
                        context,
                        "Your account is ready",
                        RoutesManager.resetPassRoute,
                      );

                    }

                  },
                  text: "Continue",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
