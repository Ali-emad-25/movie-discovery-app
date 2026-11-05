import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (context) => getIt<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;

  Color get _fieldColor =>
      _isDark ? AppColors.fieldDarkColor : AppColors.fieldLightColor;

  Color get _borderColor =>
      _isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

  Color get _textColor =>
      _isDark ? AppColors.textDarkColor : AppColors.textLightColor;

  Color get _secondaryTextColor =>
      _isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;

  Color get _hintColor =>
      _isDark ? AppColors.hintDarkColor : AppColors.hintLightColor;

  Color get _logoBgColor =>
      _isDark ? AppColors.logoBgDarkColor : AppColors.logoBgLightColor;

  Color get _primaryColor => AppColors.primaryColor;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<ForgotPasswordCubit>().sendPasswordResetEmail(
            email: _emailController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = (MediaQuery.of(context).size.width / 375).clamp(
      1.0,
      1.2,
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ForgotPasswordSuccess) {
              return _buildSuccessView(context, state.email, scale);
            }

            final bool isLoading = state is ForgotPasswordLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28 * scale, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12 * scale),

                    // Glowing Branding Header
                    Center(
                      child: Container(
                        width: 72 * scale,
                        height: 72 * scale,
                        decoration: BoxDecoration(
                          color: _logoBgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withValues(alpha: 0.25),
                              blurRadius: 32,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Icon(
                                Icons.lock_reset_rounded,
                                size: 36,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 14 * scale),

                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Movie',
                              style: TextStyle(color: _textColor),
                            ),
                            TextSpan(
                              text: 'Verse',
                              style: TextStyle(color: _primaryColor),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),

                    SizedBox(height: 36 * scale),

                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),

                    SizedBox(height: 8 * scale),

                    Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 13 * scale,
                        height: 1.45,
                      ),
                    ),

                    SizedBox(height: 28 * scale),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      style: TextStyle(color: _textColor, fontSize: 15),
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(trimmed)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: _hintColor, fontSize: 14),
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          size: 22,
                          color: _secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: _fieldColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: _borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: _borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: _primaryColor, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                      ),
                    ),

                    SizedBox(height: 24 * scale),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50 * scale,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _primaryColor.withValues(alpha: 0.6),
                          elevation: 6,
                          shadowColor: _primaryColor.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 24 * scale),

                    // Back to login button
                    Center(
                      child: TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back_rounded, size: 16, color: _secondaryTextColor),
                        label: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, String email, double scale) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28 * scale, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80 * scale,
              height: 80 * scale,
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _primaryColor.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 42 * scale,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 24 * scale),
            Text(
              'Reset Link Sent!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 23 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10 * scale),
            Text(
              'We have sent a password reset link to:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _secondaryTextColor,
                fontSize: 13 * scale,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primaryColor,
                fontSize: 14 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 14 * scale),
            Text(
              'Please check your inbox (and spam folder) and follow the instructions to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _secondaryTextColor,
                fontSize: 12 * scale,
                height: 1.45,
              ),
            ),
            SizedBox(height: 32 * scale),
            SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: _primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 13 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12 * scale),
            TextButton(
              onPressed: () {
                context.read<ForgotPasswordCubit>().reset();
              },
              child: Text(
                'Resend to a different email',
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
