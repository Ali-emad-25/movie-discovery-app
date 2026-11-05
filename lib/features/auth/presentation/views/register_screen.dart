import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

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
  final formKey = GlobalKey<FormState>();

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

  void register() {
    if (formKey.currentState?.validate() != true) return;

    context.read<AuthCubit>().register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void signInWithGoogle() {
    context.read<AuthCubit>().signInWithGoogle(isRegister: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppToast.success(context, message: 'auth.register_success'.tr());

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.homeScreenRouteName,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(28.w, 48.h, 28.w, 16.h),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: AuthHeader()),

                          SizedBox(height: 42.h),

                          Text(
                            'auth.create_account'.tr(),
                            style: theme.textTheme.bodyLarge,
                          ),

                          SizedBox(height: 2.h),

                          Text(
                            'auth.join_to_start'.tr(),
                            style: theme.textTheme.bodySmall,
                          ),

                          SizedBox(height: 20.h),

                          // Full Name
                          AuthTextField(
                            hint: 'auth.full_name'.tr(),
                            prefixIcon: Icons.person_outline,
                            controller: nameController,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'auth.name_required'.tr();
                              }

                              if (value.trim().length < 2) {
                                return 'auth.name_invalid'.tr();
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 13.h),

                          // Email
                          AuthTextField(
                            hint: 'auth.email'.tr(),
                            prefixIcon: Icons.mail_outline,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'auth.email_required'.tr();
                              }

                              final emailRegex = RegExp(
                                r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                              );

                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'auth.invalid_email'.tr();
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 13.h),

                          // Password
                          AuthTextField(
                            hint: 'auth.password'.tr(),
                            prefixIcon: Icons.lock_outline,
                            controller: passwordController,
                            isPassword: true,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'auth.password_required'.tr();
                              }

                              if (value.length < 6) {
                                return 'auth.weak_password'.tr();
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 13.h),

                          // Confirm Password
                          AuthTextField(
                            hint: 'auth.confirm_password'.tr(),
                            prefixIcon: Icons.lock_outline,
                            controller: confirmPasswordController,
                            isPassword: true,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'auth.confirm_password_required'.tr();
                              }

                              if (value != passwordController.text) {
                                return 'auth.passwords_not_match'.tr();
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 19.h),

                          // Register Button
                          MainBtn(
                            text: 'auth.sign_up'.tr(),
                            isLoading: isLoading,
                            onPressed: isLoading ? null : register,
                          ),

                          SizedBox(height: 25.h),

                          // Divider
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
                                  'auth.or_continue_with'.tr(),
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

                          // Google Button
                          SecondBtn(
                            text: 'auth.continue_with_google'.tr(),
                            onPressed: isLoading ? null : signInWithGoogle,
                            isGoogle: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Login Navigation
                Padding(
                  padding: EdgeInsets.only(bottom: 25.h, top: 15.h),
                  child: Row(
                    spacing: 5.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'auth.already_have_account'.tr(),
                        style: theme.textTheme.bodySmall,
                      ),

                      TextBtn(
                        text: 'auth.login'.tr(),
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
            ),
          ),
        );
      },
    );
  }
}
