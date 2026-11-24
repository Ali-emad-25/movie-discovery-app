import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_cubit.dart';
import 'package:movie_discovery_app/features/auth/presentation/view_models/auth_state.dart';
import 'package:movie_discovery_app/features/discover/presentation/view_models/discover_cubit.dart';
import 'package:movie_discovery_app/features/discover/presentation/view_models/discover_state.dart';
import 'package:movie_discovery_app/features/discover/presentation/views/discover_tab.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/views/home_tab.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_cubit.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_state.dart';
import 'package:movie_discovery_app/features/profile/presentation/views/profile_tab.dart';
import 'package:movie_discovery_app/features/search/presentation/views/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  static HomeScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late final DiscoverCubit _discoverCubit;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _discoverCubit = getIt<DiscoverCubit>()..fetchDiscoverData();
  }

  @override
  void dispose() {
    _discoverCubit.close();
    super.dispose();
  }

  void switchToDiscover({
    DiscoverType type = DiscoverType.movies,
    DiscoverFilter filter = DiscoverFilter.all,
  }) {
    setState(() {
      _currentIndex = 1;
    });
    _discoverCubit.fetchDiscoverData(type: type, filter: filter);
  }

  late final List<Widget> _screens = [
    const HomeTab(),
    const DiscoverTab(),
    const _PlaceholderScreen(
      title: 'nav.library',
      icon: Icons.video_library_outlined,
    ),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final titles = [
      'nav.home'.tr(),
      'nav.discover'.tr(),
      'nav.library'.tr(),
      'nav.profile'.tr(),
    ];
    Widget avatar = Icon(
      Icons.person_outline,
      color: Colors.white,
      size: 25.sp,
    );

    return BlocProvider<DiscoverCubit>.value(
      value: _discoverCubit,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w),
          child: Image.asset(AppAssets.logo),
        ),
        title: Text(titles[_currentIndex], style: theme.textTheme.titleLarge),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
            child: Icon(Icons.search, size: 25.sp),
          ),
          SizedBox(width: 15.w),
          InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.notificationsRouteName,
            ),
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final count = switch (state) {
                  NotificationsLoaded(:final reminders) => reminders.length,
                  _ => 0,
                };
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications_outlined, size: 25.sp),
                    if (count > 0)
                      Positioned(
                        top: -2.h,
                        right: -2.w,
                        child: Container(
                          width: 9.r,
                          height: 9.r,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 15.w),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final user = switch (state) {
                AuthSuccess(user: final user) => user,
                AuthLoginSuccess(user: final user) => user,
                _ => const User.guest(),
              };

              return CircleAvatar(
                radius: 18.r,
                backgroundColor: colors.primary,
                child:
                    user.isGuest ||
                        user.photoUrl == null ||
                        user.photoUrl!.isEmpty
                    ? avatar
                    : ClipOval(
                        child: Image.network(
                          user.photoUrl!,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => avatar,
                          loadingBuilder: (_, child, progress) {
                            return progress == null ? child : avatar;
                          },
                        ),
                      ),
              );
            },
          ),
        ],
      ),

      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: 'nav.home'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: 'nav.discover'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.video_library_outlined),
            selectedIcon: const Icon(Icons.video_library_rounded),
            label: 'nav.library'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: 'nav.profile'.tr(),
          ),
        ],
      ),
    ),
  );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50.sp, color: theme.colorScheme.primary),
          SizedBox(height: 12.h),
          Text(title.tr(), style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
