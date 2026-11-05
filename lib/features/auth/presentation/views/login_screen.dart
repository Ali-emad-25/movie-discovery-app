
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/text_btn.dart';

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
      isDark ? AppColors.bgDarkColor : AppColors.loginLightColor;

  Color get fieldColor =>
      isDark ? AppColors.fieldDarkBlueColor : AppColors.fieldGrayColor;

  Color get borderColor =>
      isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

  Color get textColor =>
      isDark ? AppColors.textDarkColor : AppColors.textLightColor;

  Color get secondaryTextColor =>
      isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;

  Color get hintColor =>
      isDark ? AppColors.hintDarkColor : AppColors.hintLightColor;

  Color get mutedTextColor =>
      isDark ? AppColors.mutedTextDarkColor : AppColors.mutedTextLightColor;

  Color get dividerColor =>
      isDark ? AppColors.dividerDarkColor : AppColors.dividerLightColor;

  Color get logoBgColor =>
      isDark ? AppColors.logoBgDarkColor : AppColors.logoBgLightColor;

  Color get linkColor =>
      isDark ? AppColors.primaryTextDarkColor : AppColors.primaryColor;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final settings = context.read<SettingsCubit>().state;
      final locale = Locale(settings.settings.languageCode);

      if (context.locale != locale) {
        await context.setLocale(locale);
      }

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

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.login_error'.tr())),
      );
      return;
    }

    context.read<AuthCubit>().login(
      email: email,
      password: password,
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return SizedBox(
      height: 50.h,
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscurePassword,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        textInputAction: isPassword
            ? TextInputAction.done
            : TextInputAction.next,
        onSubmitted: isPassword ? (_) => _submit() : null,
        autocorrect: false,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 22.sp,
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
            borderSide: BorderSide(color: linkColor),
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

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.welcome'.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 23.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'auth.sign_in_subtitle'.tr(),
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: logoBgColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.22),
                  blurRadius: 30,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(0.8.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.r),
                child: Image.asset(
                  AppAssets.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text.rich(
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
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
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
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      28.w,
                      40.h,
                      28.w,
                      16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!isDark) ...[
                          _buildWelcome(),
                          SizedBox(height: 36.h),
                        ],

                        _buildLogo(),

                        SizedBox(height: isDark ? 42.h : 22.h),

                        if (isDark) ...[
                          _buildWelcome(),
                          SizedBox(height: 22.h),
                        ],

                        _buildTextField(
                          hint: 'auth.email'.tr(),
                          prefixIcon: Icons.alternate_email,
                          controller: emailController,
                        ),

                        SizedBox(height: 13.h),

                        _buildTextField(
                          hint: 'auth.password'.tr(),
                          prefixIcon: Icons.lock_outline,
                          controller: passwordController,
                          isPassword: true,
                        ),

                        SizedBox(height: 12.h),

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
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'auth.forgot_password'.tr(),
                              style: TextStyle(
                                color: linkColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 19.h),

                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: AppColors.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              'auth.login'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              FocusScope.of(context).unfocus();
                              context.read<AuthCubit>().continueAsGuest();
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: fieldColor,
                              foregroundColor: secondaryTextColor,
                              padding: EdgeInsets.zero,
                              side: BorderSide(color: borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                            ),
                            child: Text(
                              'auth.guest'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
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
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'auth.or_continue'.tr(),
                                style: TextStyle(
                                  color: mutedTextColor,
                                  fontSize: 11.sp,
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

                        SizedBox(height: 19.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              onPressed: () => showComingSoon(context),
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
                              onPressed: () => showComingSoon(context),
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
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 24.h),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'auth.no_account'.tr(),
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12.sp,
                        ),
                      ),
                      TextBtn(
                        text: 'auth.sign_up'.tr(),
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
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
