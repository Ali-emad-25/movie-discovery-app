
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';
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

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get fieldColor => isDark
      ? AppColors.fieldDarkBlueColor
      : AppColors.fieldWhiteColor;

  Color get borderColor => isDark
      ? AppColors.borderDarkColor
      : AppColors.borderLightColor;

  Color get textColor => isDark
      ? AppColors.textDarkColor
      : AppColors.textLightColor;

  Color get secondaryTextColor => isDark
      ? AppColors.secondaryTextDarkColor
      : AppColors.secondaryTextLightColor;

  Color get hintColor => isDark
      ? AppColors.hintDarkColor
      : AppColors.hintLightColor;

  Color get dividerColor => isDark
      ? AppColors.dividerDarkColor
      : AppColors.dividerLightColor;

  Color get logoBgColor => isDark
      ? AppColors.logoBgDarkColor
      : AppColors.logoBgLightColor;

  Color get primaryColor => AppColors.primaryColor;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    final isObscured = isPassword || isConfirmPassword;

    final obscureText = isPassword
        ? obscurePassword
        : isConfirmPassword
        ? obscureConfirmPassword
        : false;

    return SizedBox(
      height: 50.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          color: textColor,
          fontSize: 13.sp,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 18.sp,
            color: secondaryTextColor,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 42.w,
            minHeight: 48.h,
          ),
          suffixIcon: isObscured
              ? IconButton(
            onPressed: () {
              setState(() {
                if (isPassword) {
                  obscurePassword = !obscurePassword;
                } else {
                  obscureConfirmPassword =
                  !obscureConfirmPassword;
                }
              });
            },
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 17.sp,
              color: secondaryTextColor,
            ),
          )
              : null,
          filled: true,
          fillColor: fieldColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.r),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.r),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.r),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 46.w,
      height: 46.h,
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

  void _register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      _showMessage('Please enter a valid email address');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().register(
      name: name,
      email: email,
      password: password,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _showMessage('Account created successfully!');
            } else if (state is AuthFailure) {
              _showMessage(state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      28.w,
                      48.h,
                      28.w,
                      16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 64.w,
                            height: 64.w,
                            decoration: BoxDecoration(
                              color: logoBgColor,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11.r),
                              child: Image.asset(
                                AppAssets.logo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 42.h),

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
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),

                        SizedBox(height: 42.h),

                        Text(
                          'Create Account',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 23.sp,
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

                        _buildTextField(
                          hint: 'Full Name',
                          prefixIcon: Icons.person_outline,
                          controller: nameController,
                        ),

                        SizedBox(height: 13.h),

                        _buildTextField(
                          hint: 'Email',
                          prefixIcon: Icons.mail_outline,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 13.h),

                        _buildTextField(
                          hint: 'Password',
                          prefixIcon: Icons.lock_outline,
                          controller: passwordController,
                          isPassword: true,
                        ),

                        SizedBox(height: 13.h),

                        _buildTextField(
                          hint: 'Confirm Password',
                          prefixIcon: Icons.lock_outline,
                          controller: confirmPasswordController,
                          isConfirmPassword: true,
                        ),

                        SizedBox(height: 19.h),

                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                              width: 21.w,
                              height: 21.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: dividerColor,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                              ),
                              child: Text(
                                'or continue with',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: dividerColor,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 19.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              onPressed: () {},
                              icon: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            _buildSocialButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.apple,
                                size: 22.sp,
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
                  padding: EdgeInsets.fromLTRB(
                    12.w,
                    10.h,
                    12.w,
                    24.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: theme.textTheme.bodySmall,
                      ),
                      TextBtn(
                        text: 'Login',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginScreenRouteName,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
