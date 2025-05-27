import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/core/success_dialog.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_text_field.dart';
import '../../../core/colors_manager.dart';
import '../../cubit/auth_cubit/auth_cubit.dart';
import '../../cubit/auth_cubit/auth_state.dart';

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
                title: const Text('Session Expired'),
                content: const Text(
                  'Your session has expired. Please sign in again.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
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
      body: Container(
        width: double.infinity,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsManager.primaryGradientStart,
              ColorsManager.primaryGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Hatley',
                style: GoogleFonts.exo2(
                  color: ColorsManager.white,
                  fontSize: 26,
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
              const SizedBox(height: 10),
              Text(
                'Sign in to continue',
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
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      icon: Icons.email,
                      hint: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      icon: Icons.lock,
                      hint: 'Password',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.forgotPassRoute,
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: ColorsManager.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is SignInLoading) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                          );
                        } else {
                          if (mounted && Navigator.canPop(context)) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        }

                        if (state is SignInSuccess) {
                          showSuccessDialog(
                            context,
                            "Logged In Successfully",
                            RoutesManager.homeRoute,
                          );
                        } else if (state is SignInFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          bgColor: ColorsManager.white,
                          foColor: ColorsManager.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                          text: 'Sign In',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesManager.signUpRoute);
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: ColorsManager.white),
                      ),
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
