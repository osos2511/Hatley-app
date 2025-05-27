import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import '../../../core/success_dialog.dart';


class EnterEmailOrPass extends StatefulWidget {
  const EnterEmailOrPass({super.key});

  @override
  State<EnterEmailOrPass> createState() => _EnterEmailOrPassState();
}

class _EnterEmailOrPassState extends State<EnterEmailOrPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;


    return Scaffold(
      body: Container(
        width: double.infinity,
        height: screenSize.height,
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsManager.primaryGradientStart, ColorsManager.primaryGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.08,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                   Text(
                    "Enter your email address to receive a reset code",
                    style: GoogleFonts.exo2(
                      fontSize: 16,
                      color: ColorsManager.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  CustomTextField(
                    icon: Icons.email,
                    hint: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),
                  CustomButton(
                    bgColor: ColorsManager.white,
                    foColor: ColorsManager.blue,
                    onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(color: ColorsManager.white),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context); // remove loading
                      showSuccessDialog(
                        context,
                        "Reset code sent to your email",
                        RoutesManager.otpRoute,
                      );
                    }
                  }, text: 'Send Code',),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Login",
                      style: TextStyle(color: ColorsManager.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
  }
}
