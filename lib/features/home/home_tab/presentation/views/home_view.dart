import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_cubit.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_state.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/featured_hero_card.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_filter_tabs.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_shimmer_loading.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/movies_horizontal_section.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/popular_people_section.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/top_rated_section.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/upcoming_releases_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..fetchHomeData(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  void _showMovieDetails(BuildContext context, Movie movie) {
    Navigator.pushNamed(
      context,
      AppRoutes.movieDetailsRouteName,
      arguments: movie.id,
    );
  }

  void _showPersonDetails(BuildContext context, Person person) {
    showComingSoon(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const HomeShimmerLoading();
        }

        if (state is HomeError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.errorLightColor,
                    size: 48.sp,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().fetchHomeData(),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is HomeLoaded) {
          final filterIndex = state.selectedFilterIndex;

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => context.read<HomeCubit>().fetchHomeData(),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              children: [
                // Filter Tabs (Category Pills Rail)
                HomeFilterTabs(
                  selectedIndex: filterIndex,
                  onSelectTab: (index) {
                    context.read<HomeCubit>().setFilterIndex(index);
                  },
                ),

                SizedBox(height: 14.h),

                // Featured Hero Banner (Shown on All or Now Playing)
                if (filterIndex == 0 || filterIndex == 5) ...[
                  FeaturedHeroCard(
                    movie: state.featuredMovie,
                    onDetails: () {
                      if (state.featuredMovie != null) {
                        _showMovieDetails(context, state.featuredMovie!);
                      }
                    },
                    onWatch: () => showComingSoon(context),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 1. Trending Section (All or Trending tab)
                if (filterIndex == 0 || filterIndex == 1) ...[
                  MoviesHorizontalSection(
                    title: 'home.sections.trending'.tr(),
                    accentColor: const Color(0xFFF59E0B), // Amber accent
                    movies: state.trendingMovies,
                    onSeeAll: () => showComingSoon(context),
                    onMovieTap: (movie) => _showMovieDetails(context, movie),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 2. Top Rated Section (All or Top Rated tab)
                if (filterIndex == 0 || filterIndex == 2) ...[
                  TopRatedSection(
                    movies: state.topRatedMovies,
                    maxItems: filterIndex == 2 ? state.topRatedMovies.length : 3,
                    onSeeAll: () => showComingSoon(context),
                    onMovieTap: (movie) => _showMovieDetails(context, movie),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 3. Popular Section (All or Popular tab)
                if (filterIndex == 0 || filterIndex == 3) ...[
                  MoviesHorizontalSection(
                    title: 'home.sections.popular'.tr(),
                    accentColor: const Color(0xFF7C3AED), // Purple accent
                    movies: state.popularMovies,
                    onSeeAll: () => showComingSoon(context),
                    onMovieTap: (movie) => _showMovieDetails(context, movie),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 4. Popular People Section (All or Popular People tab)
                if (filterIndex == 0 || filterIndex == 4) ...[
                  PopularPeopleSection(
                    people: state.popularPeople,
                    onSeeAll: () => showComingSoon(context),
                    onPersonTap: (person) => _showPersonDetails(context, person),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 5. Now Playing Section (All or Now Playing tab)
                if (filterIndex == 0 || filterIndex == 5) ...[
                  MoviesHorizontalSection(
                    title: 'home.sections.now_playing'.tr(),
                    accentColor: const Color(0xFF34C759), // Green accent
                    movies: state.nowPlayingMovies,
                    onSeeAll: () => showComingSoon(context),
                    onMovieTap: (movie) => _showMovieDetails(context, movie),
                  ),
                  SizedBox(height: 22.h),
                ],

                // 6. Upcoming Releases Section (All or Upcoming tab)
                if (filterIndex == 0 || filterIndex == 6) ...[
                  UpcomingReleasesSection(
                    movies: state.upcomingMovies,
                    onMovieTap: (movie) => _showMovieDetails(context, movie),
                  ),
                  SizedBox(height: 16.h),
                ],
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
