import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/settings_cubit.dart';
import 'package:movie_discovery_app/core/widgets/app_dialog.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/account_settings/presentation/views/account_settings_screen.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_cubit.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_state.dart';
import 'package:movie_discovery_app/features/profile/presentation/view_models/profile_cubit.dart';
import 'package:movie_discovery_app/features/profile/presentation/view_models/profile_state.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _performLogout(BuildContext context) async {
    await context.read<ProfileCubit>().logout();
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await AppDialog.show(
      context: context,
      title: 'profile.logout'.tr(),
      message: 'profile.logout_confirm'.tr(),
      icon: Icons.logout_rounded,
      confirmText: 'profile.logout'.tr(),
      cancelText: 'common.cancel'.tr(),
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await _performLogout(context);
    }
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    final result = await AppDialog.show(
      context: context,
      title: 'profile.login_required'.tr(),
      message: 'profile.login_required_message'.tr(),
      icon: Icons.lock_outline_rounded,
      confirmText: 'common.login'.tr(),
      cancelText: 'common.cancel'.tr(),
    );

    if (result == true && context.mounted) {
      await _performLogout(context);
    }
  }

  Future<void> _requireAccount(
    BuildContext context,
    User user,
    VoidCallback action,
  ) async {
    if (user.isGuest) {
      await _showLoginDialog(context);
      return;
    }

    action();
  }

  Future<void> _openAccountSettings(BuildContext context, User user) async {
    final profileUpdated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => AccountSettingsScreen(user: user),
      ),
    );
    if (profileUpdated == true && context.mounted) {
      await context.read<ProfileCubit>().loadProfile();
    }
  }

  Widget _userCard(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    const avatar = Icon(Icons.person_outline, color: Colors.white, size: 30);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF2A124E), Color(0xFF1B1838)]
              : const [Colors.white, Color(0xFFF7F1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark
              ? const Color(0xFF4C2A7D).withValues(alpha: 0.5)
              : theme.dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: colors.primary,
            child:
                user.isGuest || user.photoUrl == null || user.photoUrl!.isEmpty
                ? avatar
                : ClipOval(
                    child:
                        user.photoUrl!.startsWith('http://') ||
                            user.photoUrl!.startsWith('https://')
                        ? Image.network(
                            user.photoUrl!,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => avatar,
                            loadingBuilder: (_, child, progress) {
                              return progress == null ? child : avatar;
                            },
                          )
                        : Image.file(
                            File(user.photoUrl!),
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => avatar,
                          ),
                  ),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.isGuest
                      ? 'profile.guest'.tr()
                      : (user.displayName?.trim().isNotEmpty == true
                            ? user.displayName!
                            : 'profile.user'.tr()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.white : null,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  user.isGuest
                      ? 'profile.guest_message'.tr()
                      : (user.email.isEmpty
                            ? 'profile.no_email'.tr()
                            : user.email),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, Color color, String title) {
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => showComingSoon(context),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, size: 18.sp, color: color),
                ),

                SizedBox(height: 6.h),

                Text('0', style: theme.textTheme.titleLarge),

                SizedBox(height: 4.h),

                Text(
                  title.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurfaceVariant,
        size: 22.sp,
      ),
      title: Text(title.tr(), style: theme.textTheme.bodyMedium),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
      onTap: onTap,
    );
  }

  Widget _menu(BuildContext context, User user) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.error != null) {
          AppToast.error(context, message: state.error!.tr());
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final settings = context.read<SettingsCubit>();

        return Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // Account
              _menuItem(
                context,
                Icons.manage_accounts_outlined,
                'profile.account',
                onTap: () => _openAccountSettings(context, user),
              ),

              Divider(
                color: theme.dividerColor,
                indent: 16,
                endIndent: 16,
                height: 1,
              ),

              // Notifications
              _menuItem(
                context,
                Icons.notifications_outlined,
                'profile.notifications',
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.notificationsRouteName,
                ),
                trailing: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, notifState) {
                    final count = switch (notifState) {
                      NotificationsLoaded(:final reminders) => reminders.length,
                      _ => 0,
                    };
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (count > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            margin: EdgeInsetsDirectional.only(end: 6.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.16,
                              ),
                              borderRadius: BorderRadius.circular(9999.r),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    );
                  },
                ),
              ),

              Divider(
                color: theme.dividerColor,
                indent: 16,
                endIndent: 16,
                height: 1,
              ),

              // Language
              _menuItem(
                context,
                Icons.translate,
                'profile.language',
                onTap: state.isSaving
                    ? null
                    : () => _requireAccount(
                        context,
                        user,
                        () => settings.setLanguage(
                          state.settings.languageCode == 'en' ? 'ar' : 'en',
                        ),
                      ),
                trailing: Text(
                  state.settings.languageCode == 'ar' ? 'العربية' : 'English',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              Divider(
                color: theme.dividerColor,
                indent: 16,
                endIndent: 16,
                height: 1,
              ),

              // Dark Mode
              _menuItem(
                context,
                Icons.dark_mode_outlined,
                'profile.dark_mode',
                onTap: state.isSaving
                    ? null
                    : () => _requireAccount(
                        context,
                        user,
                        () => settings.setDarkMode(!state.settings.isDark),
                      ),
                trailing: Switch(
                  value: state.settings.isDark,
                  activeTrackColor: theme.colorScheme.primary,
                  onChanged: state.isSaving
                      ? null
                      : (value) => _requireAccount(
                          context,
                          user,
                          () => settings.setDarkMode(value),
                        ),
                ),
              ),

              Divider(
                color: theme.dividerColor,
                indent: 16,
                endIndent: 16,
                height: 1,
              ),

              // About - available for everyone
              _menuItem(
                context,
                Icons.info_outline,
                'profile.about',
                onTap: () => showComingSoon(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            AppToast.success(context, message: 'auth.logout_success'.tr());

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreenRouteName,
              (_) => false,
            );
          } else if (state is ProfileFailure && state.user != null) {
            AppToast.error(context, message: state.message.tr());
          }
        },
        builder: (context, state) {
          User? user;

          if (state is ProfileSuccess) {
            user = state.user;
          }

          if (state is ProfileFailure) {
            user = state.user;
          }

          if (user == null) {
            if (state is ProfileFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),

                      SizedBox(height: 12.h),

                      TextButton(
                        onPressed: context.read<ProfileCubit>().loadProfile,
                        child: Text('common.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          final loading = state is ProfileSuccess && state.isLoggingOut;

          return ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              _userCard(context, user),

              SizedBox(height: 24.h),

              Row(
                children: [
                  _stat(
                    context,
                    Icons.bookmark_border,
                    colors.primary,
                    'profile.watchlist',
                  ),

                  SizedBox(width: 12.w),

                  _stat(
                    context,
                    Icons.history,
                    Colors.orange,
                    'profile.history',
                  ),

                  SizedBox(width: 12.w),

                  _stat(
                    context,
                    Icons.favorite,
                    colors.error,
                    'profile.favorite',
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _menu(context, user),

              SizedBox(height: 24.h),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error,
                  minimumSize: Size.fromHeight(48.h),
                  side: BorderSide(color: colors.error.withValues(alpha: 0.4)),
                  shape: const StadiumBorder(),
                ),
                onPressed: loading ? null : () => _logout(context),
                icon: loading
                    ? SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout, size: 18),
                label: Text('profile.logout'.tr()),
              ),

              SizedBox(height: 24.h),

              Text(
                'MovieVerse Pro v1.0.0',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),

              SizedBox(height: 4.h),

              Text(
                'profile.footer'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),

              SizedBox(height: 12.h),
            ],
          );
        },
      ),
    );
  }
}
