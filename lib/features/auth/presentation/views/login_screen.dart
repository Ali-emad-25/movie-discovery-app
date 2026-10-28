import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/second_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/main_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/text_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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

                    Text('Welcome Back', style: theme.textTheme.bodyLarge),

                    SizedBox(height: 2.h),

                    Text(
                      'Sign in to continue',
                      style: theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 20.h),

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

                    SizedBox(height: 15.h),

                    TextBtn(text: 'Forgot password?', onTap: () {}),

                    SizedBox(height: 35.h),

                    MainBtn(text: 'Login', onPressed: () {}),

                    SizedBox(height: 12.h),

                    SecondBtn(
                      text: 'Continue as guest',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.homeScreenRouteName,
                        );
                      },
                    ),

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
                      text: 'Login with Google',
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
                    "Don't have an account? ",
                    style: theme.textTheme.bodySmall,
                  ),
                  TextBtn(
                    text: 'SignUp',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.registerScreenRouteName,
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
