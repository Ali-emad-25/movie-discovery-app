import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/view_models/account_settings_cubit.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/widgets/account_settings_sheet_components.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_state.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final changed = await context.read<AccountSettingsCubit>().changePassword(
      currentPassword: _currentPassword.text,
      newPassword: _newPassword.text,
    );
    if (changed && mounted) Navigator.pop(context);
  }

  void _sendResetLink() {
    final email = context.read<AccountSettingsCubit>().state.user.email;
    context.read<ForgotPasswordCubit>().sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AccountSettingsCubit>().state;
    final resetState = context.watch<ForgotPasswordCubit>().state;
    final isSendingReset = resetState is ForgotPasswordLoading;
    final height = MediaQuery.sizeOf(context).height;

    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, resetState) {
        if (resetState is ForgotPasswordFailure) {
          AppToast.error(context, message: resetState.message.tr());
        } else if (resetState is ForgotPasswordSuccess) {
          AppToast.success(
            context,
            message: 'account_settings.reset_email_sent'.tr(),
          );
        }
      },
      child: Container(
        height: height * 0.73,
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkColor : AppColors.cardLightColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
          border: Border.all(
            color: isDark
                ? AppColors.borderDarkColor
                : AppColors.borderLightColor,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AccountSettingsSheetHandle(
                isDark: isDark,
                topPadding: 15,
                bottomPadding: 26,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    4.h,
                    20.w,
                    18.h + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AccountSettingsSheetTitle(
                          icon: Icons.lock_reset_rounded,
                          title: 'account_settings.change_password'.tr(),
                          isDark: isDark,
                          heroIconSize: 24,
                          titleFontSize: 18,
                          titleGap: 18,
                        ),
                        SizedBox(height: 36.h),
                        AccountSettingsPasswordField(
                          label: 'account_settings.current_password'.tr(),
                          hint: 'account_settings.password_hint'.tr(),
                          controller: _currentPassword,
                          visible: _showCurrent,
                          labelFontSize: 10,
                          trailingLabel: TextButton(
                            onPressed: state.isBusy || isSendingReset
                                ? null
                                : _sendResetLink,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 18.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'account_settings.forgot_password'.tr(),
                              style: TextStyle(
                                color: AppColors.primaryTextDarkColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          onToggleVisibility: () =>
                              setState(() => _showCurrent = !_showCurrent),
                          validator: (value) => value == null || value.isEmpty
                              ? 'account_settings.password_required'.tr()
                              : null,
                        ),
                        SizedBox(height: 18.h),
                        AccountSettingsPasswordField(
                          label: 'account_settings.new_password'.tr(),
                          hint: 'account_settings.new_password_hint'.tr(),
                          controller: _newPassword,
                          visible: _showNew,
                          labelFontSize: 10,
                          onToggleVisibility: () =>
                              setState(() => _showNew = !_showNew),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'account_settings.new_password_required'
                                  .tr();
                            }
                            if (value.length < 6) {
                              return 'account_settings.password_too_short'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 18.h),
                        AccountSettingsPasswordField(
                          label: 'account_settings.confirm_password'.tr(),
                          hint: 'account_settings.confirm_password_hint'.tr(),
                          controller: _confirmPassword,
                          visible: _showConfirm,
                          labelFontSize: 10,
                          onToggleVisibility: () =>
                              setState(() => _showConfirm = !_showConfirm),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'account_settings.confirm_password_required'
                                  .tr();
                            }
                            if (value != _newPassword.text) {
                              return 'account_settings.passwords_do_not_match'
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          height: 48.h,
                          child: FilledButton(
                            onPressed: state.isBusy ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                            ),
                            child: state.isChangingPassword
                                ? const AccountSettingsButtonProgress()
                                : Text(
                                    'account_settings.change_password_action'
                                        .tr(),
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 48.h,
                          child: FilledButton.tonal(
                            onPressed: state.isBusy
                                ? null
                                : () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.cardDarkColor
                                  : AppColors.borderLightColor,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'common.cancel'.tr(),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
