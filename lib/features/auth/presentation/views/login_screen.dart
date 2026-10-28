import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? AppColors.bgDarkColor : AppColors.loginLightColor;

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
  Color get linkColor => isDark ? AppColors.primaryTextDarkColor : primaryColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final settings = context.read<SettingsCubit>().state;
      final locale = Locale(settings.settings.languageCode);
      if (context.locale != locale) await context.setLocale(locale);
      if (!mounted) return;
      final error = settings.error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.tr())),
        );
      }
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(
      email: emailController.text,
      password: passwordController.text,
    );
  }

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
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
        onSubmitted: isPassword ? (_) => _submit() : null,
        autocorrect: false,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 13),
          prefixIcon: Icon(prefixIcon, size: 22, color: secondaryTextColor),
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
            borderSide: BorderSide(color: linkColor),
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

  Widget _buildWelcome(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.welcome'.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 23 * scale,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: 5 * scale),
        Text(
          'auth.sign_in_subtitle'.tr(),
          style: TextStyle(color: secondaryTextColor, fontSize: 12 * scale),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        if (state is AuthLoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.profileScreenRouteName,
            (_) => false,
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.tr())),
          );
        }
      },
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final double scale = (MediaQuery.of(context).size.width / 375).clamp(
      1.0,
      1.2,
    );

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
                    if (!isDark) ...[
                      _buildWelcome(scale),
                      SizedBox(height: 36 * scale),
                    ],
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
                              style: TextStyle(color: linkColor),
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

                    SizedBox(height: (isDark ? 42 : 22) * scale),
                    if (isDark) ...[
                      _buildWelcome(scale),
                      SizedBox(height: 22 * scale),
                    ],

                    buildTextField(
                      hint: 'auth.email'.tr(),
                      prefixIcon: Icons.alternate_email,
                      controller: emailController,
                    ),

                    SizedBox(height: 13 * scale),

                    buildTextField(
                      hint: 'auth.password'.tr(),
                      prefixIcon: Icons.lock_outline,
                      controller: passwordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 7 * scale),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordScreenRouteName,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 7,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'auth.forgot_password'.tr(),
                          style: TextStyle(
                            color: linkColor,
                            fontSize: 11 * scale,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 19 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 48 * scale,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) => ElevatedButton(
                          onPressed: state is AuthLoading ? null : _submit,
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
                          child: state is AuthLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'auth.login'.tr(),
                                  style: TextStyle(
                                    fontSize: 13 * scale,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 48 * scale,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) => OutlinedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : context.read<AuthCubit>().continueAsGuest,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: fieldColor,
                            foregroundColor: secondaryTextColor,
                            padding: EdgeInsets.zero,
                            side: BorderSide(color: borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'auth.guest'.tr(),
                            style: TextStyle(
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25 * scale),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                          child: Text(
                            'auth.or_continue'.tr(),
                            style: TextStyle(
                              color: mutedTextColor,
                              fontSize: 11 * scale,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 19 * scale),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSocialButton(
                          onPressed: () => showComingSoon(context),
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
                          onPressed: () => showComingSoon(context),
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
              padding: EdgeInsets.fromLTRB(12, 10, 12, 24 * scale),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${'auth.no_account'.tr()} ',
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.registerScreenRouteName,
                      );
                    },
                    child: Text(
                      'auth.sign_up'.tr(),
                      style: TextStyle(
                        color: linkColor,
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
