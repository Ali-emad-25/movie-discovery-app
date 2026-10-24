
import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  bool obscurePassword = true;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscurePassword,
        keyboardType: hint == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 22,
            color: secondaryTextColor,
          ),
          suffixIcon: isPassword
              ? IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: Icon(
              obscurePassword
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
    final double scale =
    (MediaQuery.of(context).size.width / 375).clamp(1.0, 1.2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  28 * scale,
                  48 * scale,
                  28 * scale,
                  16,
                ),
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
                              color: primaryColor.withOpacity(0.22),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10 * scale),

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
                      'Welcome Back',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 23 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),

                    SizedBox(height: 5 * scale),

                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12 * scale,
                      ),
                    ),

                    SizedBox(height: 22 * scale),

                    buildTextField(
                      hint: 'Email',
                      prefixIcon: Icons.mail_outline,
                      controller: emailController,
                    ),

                    SizedBox(height: 13 * scale),

                    buildTextField(
                      hint: 'Password',
                      prefixIcon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 7 * scale),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 7,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11 * scale,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 19 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 48 * scale,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.4),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 48 * scale,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: fieldColor,
                          foregroundColor: textColor,
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Continue as guest',
                          style: TextStyle(
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25 * scale),

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
                            horizontal: 10 * scale,
                          ),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              color: mutedTextColor,
                              fontSize: 11 * scale,
                            ),
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

                    SizedBox(height: 19 * scale),

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
                              color: Theme.of(context).brightness == Brightness.light
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

            // Sign Up
            Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                10,
                12,
                24 * scale,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.registerScreenRouteName,
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
