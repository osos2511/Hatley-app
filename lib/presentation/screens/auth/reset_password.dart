import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import '../../../core/colors_manager.dart';
import '../../../core/success_dialog.dart';
import '../../../core/routes_manager.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
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
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.primaryGradientStart, ColorsManager.primaryGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.15,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Please enter a new password to reset your account",
                    style: GoogleFonts.exo2(
                      fontSize: 16,
                      color: ColorsManager.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock_open,
                    isPassword: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: screenHeight * 0.06),
                  CustomButton(
                    bgColor: ColorsManager.white,
                    foColor: ColorsManager.blue,
                    onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showSuccessDialog(
                        context,
                        "Your password has been reset successfully!",
                        RoutesManager.signInRoute,
                      );
                    }
                  }, text: 'Reset Password',),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
