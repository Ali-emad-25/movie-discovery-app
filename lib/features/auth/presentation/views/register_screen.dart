import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/second_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/main_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/text_btn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(28.w, 48.h, 28.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AuthHeader()),

                    SizedBox(height: 42.h),

                    Text('Create Account', style: theme.textTheme.bodyLarge),

                    SizedBox(height: 2.h),

                    Text(
                      'Join to start your journey',
                      style: theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 20.h),

                    AuthTextField(
                      hint: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      controller: nameController,
                    ),

                    SizedBox(height: 13.h),

                    AuthTextField(
                      hint: 'Email',
                      prefixIcon: Icons.mail_outline,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 13.h),

                    AuthTextField(
                      hint: 'Password',
                      prefixIcon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 13.h),

                    AuthTextField(
                      hint: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 19.h),

                    MainBtn(text: 'Sign Up', onPressed: () {}),

                    SizedBox(height: 25.h),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.dividerColor,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            'or continue with',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.dividerColor,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 19.h),

                    SecondBtn(
                      text: 'Sign Up with Google',
                      onPressed: () {},
                      isGoogle: true,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 25.h, top: 15.h),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: theme.textTheme.bodySmall,
                  ),
                  TextBtn(
                    text: 'Login',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.loginScreenRouteName,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
