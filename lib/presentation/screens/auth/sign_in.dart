import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          builder: (context) => AlertDialog(
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
      body: SizedBox(
        width: double.infinity,
        height: screenSize.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Hatley',
                style: GoogleFonts.exo2(
                  color: ColorsManager.buttonColorApp,
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
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
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
                      listener: (context, state) async {
                        if (state is SignInSuccess) {
                          Navigator.pushReplacementNamed(context, RoutesManager.homeRoute);
                        } else if (state is SignInFailure) {
                          CustomToast.show(
                            message: "Login failed. Please try again",
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is SignInLoading;

                        return CustomAuthButton(
                          text: 'Sign In',
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              final prefs = await SharedPreferences.getInstance();
                              final TokenStorage tokenStorage = TokenStorageImpl(prefs);
                              await tokenStorage.saveEmail(emailController.text.trim());
                              context.read<AuthCubit>().signIn(
                                email: emailController.text.trim(),
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
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesManager.signUpRoute);
                          },
                          child:  Text(
                            "Sign Up",
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
    );
  }
}