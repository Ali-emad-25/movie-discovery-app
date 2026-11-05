import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_state.dart';

import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/main_btn.dart';

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
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    context.read<ForgotPasswordCubit>().sendPasswordResetEmail(
      email: emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordFailure) {
              AppToast.error(context, message: state.message.tr());
            }
          },
          builder: (context, state) {
            if (state is ForgotPasswordSuccess) {
              return buildSuccessView(context, state.email);
            }

            final isLoading = state is ForgotPasswordLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 24.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12.h),

                    const Center(child: AuthHeader()),

                    SizedBox(height: 40.h),

                    Text(
                      'auth.forgot_password_title'.tr(),
                      style: theme.textTheme.titleLarge,
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'auth.forgot_password_description'.tr(),
                      style: theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 28.h),

                    AuthTextField(
                      hint: 'auth.email'.tr(),
                      prefixIcon: Icons.mail_outline,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'auth.email_required'.tr();
                        }

                        if (!RegExp(
                          r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                        ).hasMatch(value.trim())) {
                          return 'auth.invalid_email'.tr();
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 15.h),

                    SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        child: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: colors.onPrimary,
                                ),
                              )
                            : Text('auth.send_reset_link'.tr()),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: Text('auth.back_to_login'.tr()),
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

  Widget buildSuccessView(BuildContext context, String email) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 42.sp,
                color: colors.primary,
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'auth.reset_link_sent'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),

            SizedBox(height: 10.h),

            Text(
              'auth.reset_link_sent_description'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              email,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 14.h),

            Text(
              'auth.check_inbox_message'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            SizedBox(height: 32.h),

            MainBtn(
              text: 'auth.back_to_login'.tr(),
              onPressed: () => Navigator.of(context).pop(),
            ),

            SizedBox(height: 12.h),

            TextButton(
              onPressed: () {
                context.read<ForgotPasswordCubit>().reset();
                emailController.clear();
              },
              child: Text(
                'auth.resend_different_email'.tr(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
