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

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<AccountSettingsCubit>().deleteAccount(
      currentPassword: _password.text,
    );
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
    final dangerColor = AppColors.dangerColor;

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
        height: height * 0.60,
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
                          icon: Icons.delete_outline_rounded,
                          title: 'account_settings.delete_account'.tr(),
                          isDark: isDark,
                          heroIconSize: 24,
                          titleFontSize: 18,
                          titleGap: 18,
                        ),
                        SizedBox(height: 28.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.dangerSurfaceDarkColor
                                : dangerColor.withValues(alpha: 0.08),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.dangerBorderDarkColor
                                  : dangerColor.withValues(alpha: 0.22),
                            ),
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: dangerColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'account_settings.delete_warning'.tr(),
                                  style: TextStyle(
                                    color: dangerColor,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        AccountSettingsPasswordField(
                          label: 'account_settings.current_password'.tr(),
                          hint: 'account_settings.password_hint'.tr(),
                          controller: _password,
                          visible: _showPassword,
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
                              setState(() => _showPassword = !_showPassword),
                          validator: (value) => value == null || value.isEmpty
                              ? 'account_settings.password_required'.tr()
                              : null,
                        ),
                        SizedBox(height: 17.h),
                        SizedBox(
                          height: 48.h,
                          child: FilledButton(
                            onPressed: state.isBusy ? null : _delete,
                            style: FilledButton.styleFrom(
                              backgroundColor: dangerColor,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                            ),
                            child: state.isDeletingAccount
                                ? const AccountSettingsButtonProgress()
                                : Text(
                                    'account_settings.delete_action'.tr(),
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
                              foregroundColor: isDark
                                  ? Colors.white
                                  : AppColors.textLightColor,
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
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
