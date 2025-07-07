import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_auth_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
import '../../../core/colors_manager.dart';
import '../../../core/routes_manager.dart';
import '../../../injection_container.dart';
import '../../cubit/register_cubit/register_state.dart';

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
                  'Create Your Account',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.buttonColorApp,
                    fontSize: 26,
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
                const SizedBox(height: 10),
                Text(
                  'Sign up to get started',
                  style: GoogleFonts.exo2(
                    color: ColorsManager.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.name,
                        controller: userNameController,
                        hint: "Your name",
                        icon: Icons.person_outline,
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? "Name is required"
                            : null,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hint: "Email Address",
                        icon: Icons.email,
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
                      const SizedBox(height: 20),
                      CustomTextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        hint: "Phone Number",
                        icon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          } else if (!RegExp(
                            r'^\d{9,15}$',
                          ).hasMatch(value)) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 30),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            Navigator.pushReplacementNamed(context, RoutesManager.signInRoute);
                          } else if (state is RegisterFailure) {
                            CustomToast.show(
                              message: "Registration failed. Please try again.",
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is RegisterLoading;

                          return CustomAuthButton(
                            text: 'Sign Up',
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                  userName: userNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.signInRoute,
                              );
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
