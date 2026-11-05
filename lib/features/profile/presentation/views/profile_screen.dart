import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/settings_cubit.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/coming_soon.dart';
import '../../../auth/domain/entities/user.dart';
import '../view_models/profile_cubit.dart';
import '../view_models/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ProfileCubit>()..loadProfile(),
    child: const _ProfileView(),
  );
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('profile.logout'.tr()),
        content: Text('profile.logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('profile.logout'.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ProfileCubit>().logout();
    }
  }

  Widget _userCard(BuildContext context, User user) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    const avatar = Icon(Icons.person_outline, color: Colors.white, size: 30);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: dark
              ? const [AppColors.cardDarkColor, AppColors.profileDarkColor]
              : const [Colors.white, AppColors.profileLightColor],
        ),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryColor,
            child:
                user.isGuest || user.photoUrl == null || user.photoUrl!.isEmpty
                ? avatar
                : ClipOval(
                    child: Image.network(
                      user.photoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => avatar,
                      loadingBuilder: (_, child, progress) =>
                          progress == null ? child : avatar,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  user.isGuest
                      ? 'profile.guest_message'.tr()
                      : (user.email.isEmpty
                            ? 'profile.no_email'.tr()
                            : user.email),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showComingSoon(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(height: 4),
                const Text(
                  '—',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  title.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title.tr(), style: const TextStyle(fontSize: 14)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _menu(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!.tr())));
        }
      },
      builder: (context, state) {
        final settings = context.read<SettingsCubit>();
        return Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              _menuItem(
                Icons.manage_accounts_outlined,
                'profile.account',
                onTap: () => showComingSoon(context),
              ),
              const Divider(indent: 16, endIndent: 16),
              _menuItem(
                Icons.notifications_outlined,
                'profile.notifications',
                onTap: () => showComingSoon(context),
              ),
              const Divider(indent: 16, endIndent: 16),
              _menuItem(
                Icons.translate,
                'profile.language',
                onTap: state.isSaving
                    ? null
                    : () => settings.setLanguage(
                        state.settings.languageCode == 'en' ? 'ar' : 'en',
                      ),
                trailing: Text(
                  state.settings.languageCode == 'ar' ? 'العربية' : 'English',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Divider(indent: 16, endIndent: 16),
              _menuItem(
                Icons.dark_mode_outlined,
                'profile.dark_mode',
                trailing: Switch(
                  value: state.settings.isDark,
                  onChanged: state.isSaving ? null : settings.setDarkMode,
                ),
              ),
              const Divider(indent: 16, endIndent: 16),
              _menuItem(
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

  BottomNavigationBarItem _nav(IconData icon, String title) =>
      BottomNavigationBarItem(icon: Icon(icon), label: title.tr());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(AppAssets.logo, width: 34, height: 34),
            ),
            const SizedBox(width: 10),
            Text('profile.title'.tr(), style: const TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'profile.notifications'.tr(),
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoggedOut) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginScreenRouteName,
                (_) => false,
              );
            } else if (state is ProfileFailure && state.user != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message.tr())));
            }
          },
          builder: (context, state) {
            User? user;
            if (state is ProfileSuccess) user = state.user;
            if (state is ProfileFailure) user = state.user;
            if (user == null) {
              if (state is ProfileFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message.tr(), textAlign: TextAlign.center),
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
              padding: const EdgeInsets.all(16),
              children: [
                _userCard(context, user),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _stat(
                      context,
                      Icons.bookmark_border,
                      colors.primary,
                      'profile.watchlist',
                    ),
                    const SizedBox(width: 12),
                    _stat(
                      context,
                      Icons.history,
                      Colors.orange,
                      'profile.history',
                    ),
                    const SizedBox(width: 12),
                    _stat(
                      context,
                      Icons.favorite,
                      colors.error,
                      'profile.favorite',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _menu(context),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(
                      color: colors.error.withValues(alpha: 0.4),
                    ),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: loading ? null : () => _logout(context),
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout, size: 18),
                  label: Text('profile.logout'.tr()),
                ),
                const SizedBox(height: 24),
                Text(
                  'MovieVerse Pro v1.0.0',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'profile.footer'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index != 3) showComingSoon(context);
        },
        items: [
          _nav(Icons.home_outlined, 'nav.home'),
          _nav(Icons.explore_outlined, 'nav.discover'),
          _nav(Icons.bookmark_border, 'nav.watchlist'),
          _nav(Icons.person_outline, 'profile.title'),
        ],
      ),
    );
  }
}
