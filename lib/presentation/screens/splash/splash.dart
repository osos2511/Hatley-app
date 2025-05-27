import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/routes_manager.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool hasCheckedToken = false;

  double responsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (baseFontSize / 375);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          AnimatedTextKit(
            totalRepeatCount: 1,
            isRepeatingAnimation: false,
            onFinished: () {
              Future.delayed(Duration.zero, () {
                Navigator.pushReplacementNamed(context, RoutesManager.signInRoute);
              });
            },

            animatedTexts: [
              ScaleAnimatedText(
                'HATLEY',
                textStyle: GoogleFonts.rubikVinyl(
                  color: Colors.blue,
                  fontSize: responsiveFontSize(context, 60),
                  fontWeight: FontWeight.w600,
                ),
                duration: const Duration(seconds: 3),
              ),
              ScaleAnimatedText(
                'Get Anything',
                textStyle: GoogleFonts.exo2(
                  color: Colors.blue,
                  fontSize: responsiveFontSize(context, 30),
                  fontWeight: FontWeight.w600,
                ),
                duration: const Duration(seconds: 3),
              ),
            ],
          ),
          const Spacer(),
          SpinKitPianoWave(
            color: Colors.blue,
            size: screenWidth * 0.08,
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }

}
