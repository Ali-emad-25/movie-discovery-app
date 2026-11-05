import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';

import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';

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
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  void continueAsGuest() {
    context.read<AuthCubit>().continueAsGuest();
  }

  void signInWithGoogle() {
    context.read<AuthCubit>().signInWithGoogle(isRegister: false);
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AuthHeader()),

                      SizedBox(height: 42.h),

                      Text(
                        'auth.welcome_back'.tr(),
                        style: theme.textTheme.bodyLarge,
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        'auth.sign_in_to_continue'.tr(),
                        style: theme.textTheme.bodySmall,
                      ),

                      SizedBox(height: 20.h),

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

                      SizedBox(height: 13.h),

                      AuthTextField(
                        hint: 'auth.password'.tr(),
                        prefixIcon: Icons.lock_outline,
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'auth.password_required'.tr();
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 15.h),

                      TextBtn(
                        text: 'auth.forgot_password'.tr(),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordScreenRouteName,
                          );
                        },
                      ),

                      SizedBox(height: 35.h),

                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) async {
                          if (state is AuthLoginSuccess) {
                            final settingsCubit = context.read<SettingsCubit>();

                            if (state.user.isGuest) {
                              await settingsCubit.setGuestDefaults();
                              if (!context.mounted) return;

                              await context.setLocale(const Locale('en'));
                            } else {
                              await settingsCubit.loadSettings();
                              if (!context.mounted) return;

                              await context.setLocale(
                                Locale(
                                  settingsCubit.state.settings.languageCode,
                                ),
                              );
                            }

                            if (!context.mounted) return;

                            AppToast.success(
                              context,
                              message: 'auth.login_success'.tr(),
                            );

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.homeScreenRouteName,
                              (route) => false,
                            );
                          } else if (state is AuthFailure) {
                            AppToast.error(
                              context,
                              message: state.message.tr(),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return Column(
                            children: [
                              MainBtn(
                                text: 'auth.login'.tr(),
                                onPressed: isLoading ? null : login,
                                isLoading: isLoading,
                              ),

                              SizedBox(height: 12.h),

                              SecondBtn(
                                text: 'auth.continue_as_guest'.tr(),
                                onPressed: isLoading ? null : continueAsGuest,
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
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

                              SecondBtn(
                                text: 'auth.continue_with_google'.tr(),
                                onPressed: isLoading ? null : signInWithGoogle,
                                isGoogle: true,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 25.h, top: 15.h),
              child: Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.no_account'.tr(),
                    style: theme.textTheme.bodySmall,
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
  }
}
