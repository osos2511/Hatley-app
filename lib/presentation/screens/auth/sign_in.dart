import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
import '../../../core/colors_manager.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';
import '../../cubit/auth_cubit/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatley/core/local/token_storage.dart';
import 'package:hatley/l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isSessionExpired = args != null && args['sessionExpired'] == true;

    if (isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.session_expired),
                content: Text(
                  AppLocalizations.of(context)!.your_session_has_expired,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome_to_hatley,
                style: GoogleFonts.exo2(
                  color: ColorsManager.buttonColorApp,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: ColorsManager.blackShadow,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppLocalizations.of(context)!.sign_in_to_continue,
                style: GoogleFonts.exo2(
                  color: ColorsManager.white70,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 30.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      icon: Icons.email,
                      hint: AppLocalizations.of(context)!.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.name_is_required;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      icon: Icons.lock,
                      hint: AppLocalizations.of(context)!.password,
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
                    SizedBox(height: 15.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.forgotPassRoute,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgot_password,
                          style: TextStyle(color: ColorsManager.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) async {
                        if (state is SignInSuccess) {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.homeRoute,
                          );
                        } else if (state is SignInFailure) {
                          CustomToast.show(
                            message: AppLocalizations.of(context)!.login_failed,
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is SignInLoading;

                        return CustomAuthButton(
                          text: AppLocalizations.of(context)!.sign_in,
                          isLoading: isLoading,
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final TokenStorage tokenStorage =
                                          TokenStorageImpl(prefs);
                                      await tokenStorage.saveEmail(
                                        emailController.text.trim(),
                                      );
                                      context.read<AuthCubit>().signIn(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );
                                    }
                                  },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dont_have_account,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesManager.signUpRoute,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.sign_up,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
