import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import '../../../injection_container.dart';
import '../../cubit/register_cubit/register_state.dart';
import 'package:hatley/l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: screenSize.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.create_your_account,
                  style: GoogleFonts.exo2(
                    color: ColorsManager.buttonColorApp,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: ColorsManager.blackShadow,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppLocalizations.of(context)!.sign_up_to_get_started,
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
                        keyboardType: TextInputType.name,
                        controller: userNameController,
                        hint: AppLocalizations.of(context)!.your_name,
                        icon: Icons.person_outline,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? AppLocalizations.of(
                                      context,
                                    )!.name_is_required
                                    : null,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hint: AppLocalizations.of(context)!.email_address,
                        icon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.email_is_required;
                          } else if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(value)) {
                            return AppLocalizations.of(
                              context,
                            )!.enter_valid_email;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        hint: AppLocalizations.of(context)!.phone_number,
                        icon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.phone_number_is_required;
                          } else if (!RegExp(r'^\d{9,15}$').hasMatch(value)) {
                            return AppLocalizations.of(
                              context,
                            )!.enter_valid_phone;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        hint: AppLocalizations.of(context)!.password,
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
                      SizedBox(height: 30.h),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            Navigator.pushReplacementNamed(
                              context,
                              RoutesManager.signInRoute,
                            );
                          } else if (state is RegisterFailure) {
                            CustomToast.show(
                              message:
                                  AppLocalizations.of(
                                    context,
                                  )!.registration_failed,
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is RegisterLoading;

                          return CustomAuthButton(
                            text: AppLocalizations.of(context)!.sign_up,
                            isLoading: isLoading,
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<RegisterCubit>().register(
                                          userName:
                                              userNameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phone: phoneController.text.trim(),
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
                            AppLocalizations.of(context)!.already_have_account,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.signInRoute,
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.sign_in,
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
      ),
    );
  }
}
