import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/view_models/account_settings_cubit.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/view_models/account_settings_state.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/widgets/account_action_row.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/widgets/account_profile_widgets.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/widgets/change_password_sheet.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/widgets/delete_account_sheet.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/forgot_password_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  final User user;

  const AccountSettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountSettingsCubit>(param1: user)..loadProfile(),
      child: const _AccountSettingsView(),
    );
  }
}

class _AccountSettingsView extends StatefulWidget {
  const _AccountSettingsView();

  @override
  State<_AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<_AccountSettingsView> {
  final TextEditingController _nameController = TextEditingController();
  bool _profileUpdated = false;
  bool _isEditingName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _beginNameEdit(String displayName) {
    _nameController.text = displayName;
    setState(() => _isEditingName = true);
  }

  Future<void> _saveDisplayName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.error(context, message: 'account_settings.name_required'.tr());
      return;
    }
    if (name.length < 2) {
      AppToast.error(context, message: 'account_settings.name_too_short'.tr());
      return;
    }

    final saved = await context.read<AccountSettingsCubit>().updateDisplayName(
      name,
    );
    if (saved && mounted) {
      setState(() {
        _isEditingName = false;
        _profileUpdated = true;
      });
    }
  }

  Future<void> _pickProfilePhoto() async {
    File? copiedPhoto;
    final cubit = context.read<AccountSettingsCubit>();
    final userId = cubit.state.user.id;
    try {
      final pickedPhoto = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (pickedPhoto == null || !mounted) return;

      final appDirectory = await getApplicationDocumentsDirectory();
      final extension = path.extension(pickedPhoto.path).isEmpty
          ? '.jpg'
          : path.extension(pickedPhoto.path);
      final safeUserId = userId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
      final fileName =
          'profile_${safeUserId}_${DateTime.now().microsecondsSinceEpoch}$extension';
      copiedPhoto = await File(
        path.join(appDirectory.path, fileName),
      ).writeAsBytes(await pickedPhoto.readAsBytes());

      if (!mounted) {
        await copiedPhoto.delete();
        return;
      }
      final oldPhotoPath = cubit.state.user.photoUrl;
      final saved = await cubit.updateProfilePhoto(copiedPhoto.path);
      if (saved) {
        if (mounted) setState(() => _profileUpdated = true);
        final appDirectoryPrefix =
            '${appDirectory.path}${Platform.pathSeparator}';
        if (oldPhotoPath != null &&
            oldPhotoPath.startsWith(appDirectoryPrefix) &&
            oldPhotoPath != copiedPhoto.path) {
          final oldPhoto = File(oldPhotoPath);
          if (await oldPhoto.exists()) await oldPhoto.delete();
        }
      } else if (await copiedPhoto.exists()) {
        await copiedPhoto.delete();
      }
    } catch (error, stackTrace) {
      debugPrint('Profile photo update failed: $error\n$stackTrace');
      if (copiedPhoto != null && await copiedPhoto.exists()) {
        await copiedPhoto.delete();
      }
      if (mounted) {
        AppToast.error(context, message: 'errors.unknown_error'.tr());
      }
    }
  }

  Future<void> _openChangePassword() async {
    final cubit = context.read<AccountSettingsCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider(create: (_) => getIt<ForgotPasswordCubit>()),
        ],
        child: const ChangePasswordSheet(),
      ),
    );
  }

  Future<void> _openDeleteAccount() async {
    final cubit = context.read<AccountSettingsCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider(create: (_) => getIt<ForgotPasswordCubit>()),
        ],
        child: const DeleteAccountSheet(),
      ),
    );
  }

  void _back() => Navigator.of(context).pop(_profileUpdated);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark
        ? AppColors.cardSurfaceDarkColor
        : AppColors.cardLightColor;
    final border = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;

    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage ||
          previous.isDeleted != current.isDeleted,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppToast.error(context, message: state.errorMessage!.tr());
        }
        if (state.successMessage != null) {
          AppToast.success(context, message: state.successMessage!.tr());
        }
        if (state.isDeleted) {
          context.read<AuthCubit>().restoreSession();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.loginScreenRouteName,
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        final user = state.user;
        final displayName = user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : 'profile.user'.tr();

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.bgDarkColor
              : AppColors.bgLightColor,
          appBar: AppBar(
            toolbarHeight: 54.h,
            backgroundColor: isDark
                ? AppColors.bgDarkColor
                : AppColors.bgLightColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, size: 24.sp),
              onPressed: _back,
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.manage_accounts_outlined,
                    size: 19.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'account_settings.title'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textDarkColor
                        : AppColors.textLightColor,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.person_outline,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Divider(
                height: 1.h,
                color: isDark
                    ? AppColors.dividerDarkColor
                    : AppColors.dividerLightColor,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(14.w, 24.h, 14.w, 18.h),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        AccountProfileAvatar(
                          name: displayName,
                          photoUrl: user.photoUrl,
                          onEdit: _pickProfilePhoto,
                        ),
                        SizedBox(height: 24.h),
                        AccountNameField(
                          value: displayName,
                          isEditing: _isEditingName,
                          controller: _nameController,
                        ),
                        SizedBox(height: 17.h),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48.h,
                                child: FilledButton(
                                  onPressed: state.isBusy
                                      ? null
                                      : _isEditingName
                                      ? _saveDisplayName
                                      : () => _beginNameEdit(displayName),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                  ),
                                  child: state.isSavingProfile
                                      ? SizedBox(
                                          width: 18.r,
                                          height: 18.r,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        )
                                      : Text(
                                          (_isEditingName
                                                  ? 'account_settings.save_profile'
                                                  : 'account_settings.edit_profile')
                                              .tr(),
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 2.w,
                      bottom: 7.h,
                    ),
                    child: Text(
                      'account_settings.account_section'.tr(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.secondaryTextDarkColor
                            : AppColors.secondaryTextLightColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(23.r),
                      border: Border.all(color: border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        AccountActionRow(
                          title: 'account_settings.change_password'.tr(),
                          icon: Icons.lock_reset_rounded,
                          isDark: isDark,
                          onTap: state.isBusy ? null : _openChangePassword,
                        ),
                        Divider(
                          height: 1.h,
                          indent: 8.w,
                          endIndent: 8.w,
                          color: border,
                        ),
                        AccountActionRow(
                          title: 'account_settings.delete_account'.tr(),
                          icon: Icons.delete_outline_rounded,
                          isDark: isDark,
                          isDestructive: true,
                          onTap: state.isBusy ? null : _openDeleteAccount,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
