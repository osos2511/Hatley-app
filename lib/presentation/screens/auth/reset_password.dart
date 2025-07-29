import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import 'package:hatley/l10n/app_localizations.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, RoutesManager.signInRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
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
                    AppLocalizations.of(context)!.reset_password_title,
                    style: GoogleFonts.exo2(
                      fontSize: 16.sp,
                      color: ColorsManager.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.h),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    hint: AppLocalizations.of(context)!.new_password,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return AppLocalizations.of(
                          context,
                        )!.password_min_length;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: confirmPasswordController,
                    hint: AppLocalizations.of(context)!.confirm_password,
                    icon: Icons.lock_open,
                    isPassword: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.passwords_dont_match;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  CustomAuthButton(
                    onPressed: isLoading ? null : _handleResetPassword,
                    text: AppLocalizations.of(context)!.reset_password,
                    isLoading: isLoading,
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
