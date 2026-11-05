import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/second_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/main_btn.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/text_btn.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

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

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // Colors
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;

  Color get fieldColor =>
      isDark ? AppColors.fieldDarkColor : AppColors.fieldLightColor;

  Color get borderColor =>
      isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

  Color get textColor =>
      isDark ? AppColors.textDarkColor : AppColors.textLightColor;

  Color get secondaryTextColor => isDark
      ? AppColors.secondaryTextDarkColor
      : AppColors.secondaryTextLightColor;

  Color get hintColor =>
      isDark ? AppColors.hintDarkColor : AppColors.hintLightColor;

  Color get mutedTextColor =>
      isDark ? AppColors.mutedTextDarkColor : AppColors.mutedTextLightColor;

  Color get dividerColor =>
      isDark ? AppColors.dividerDarkColor : AppColors.dividerLightColor;

  Color get logoBgColor =>
      isDark ? AppColors.logoBgDarkColor : AppColors.logoBgLightColor;

  Color get primaryColor => AppColors.primaryColor;

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
  // Text Field
  Widget buildTextField({
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    bool isObscured = isPassword || isConfirmPassword;

    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? obscurePassword
            : isConfirmPassword
            ? obscureConfirmPassword
            : false,
        keyboardType: hint == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: TextStyle(color: textColor, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 13),
          prefixIcon: Icon(prefixIcon, size: 18, color: secondaryTextColor),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 48,
          ),
          suffixIcon: isObscured
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        obscurePassword = !obscurePassword;
                      } else {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      }
                    });
                  },
                  icon: Icon(
                    (isPassword ? obscurePassword : obscureConfirmPassword)
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 17,
                    color: secondaryTextColor,
                  ),
                )
              : null,
          filled: true,
          fillColor: fieldColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  // Social Button
  Widget buildSocialButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 46,
      height: 46,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: fieldColor,
          side: BorderSide(color: borderColor),
          shape: const CircleBorder(),
        ),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scale = (MediaQuery.of(context).size.width / 375).clamp(
      1.0,
      1.2,
    );

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
                    // Logo
                    Center(
                      child: Container(
                        width: 64 * scale,
                        height: 64 * scale,
                        decoration: BoxDecoration(
                          color: logoBgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.22),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
                        ),
                      ),
                    ),

                    SizedBox(height: 42.h),

                    // MovieVerse
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Movie',
                              style: TextStyle(color: textColor),
                            ),
                            TextSpan(
                              text: 'Verse',
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 19 * scale,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),

                    SizedBox(height: 42 * scale),

                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 23 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      'Join to start your journey',
                      style: theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 20.h),

                    //form
                    buildTextField(
                      hint: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      controller: nameController,
                    ),

                    SizedBox(height: 13.h),

                    buildTextField(
                      hint: 'Email',
                      prefixIcon: Icons.mail_outline,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 13 * scale),

                    buildTextField(
                      hint: 'Password',
                      prefixIcon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 13.h),

                    buildTextField(
                      hint: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 19.h),

                    // Sign Up

                    // Sign Up
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account created successfully!'),
                            ),
                          );

                          // هنضيف الانتقال للشاشة الرئيسية بعد ما نتأكد
                          // إن التسجيل شغال بنجاح.
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return SizedBox(
                          width: double.infinity,
                          height: 48 * scale,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    // Validate fields
                                    if (nameController.text.trim().isEmpty ||
                                        emailController.text.trim().isEmpty ||
                                        passwordController.text.isEmpty ||
                                        confirmPasswordController
                                            .text
                                            .isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please fill in all fields',
                                              ),
                                            ),
                                          );
                                      return;
                                    }

                                    // Validate password confirmation
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Passwords do not match',
                                              ),
                                            ),
                                          );
                                      return;
                                    }

                                    // Call AuthCubit
                                    context.read<AuthCubit>().register(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: primaryColor.withValues(alpha: 0.4),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 21,
                                    height: 21,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 25 * scale),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                          child: Text(
                            'or continue with',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 19.h),

                    // Google and Apple
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSocialButton(
                          onPressed: () {},
                          icon: Text(
                            'G',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 14 * scale),
                        buildSocialButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.apple,
                            size: 22 * scale,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 24 * scale),
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
