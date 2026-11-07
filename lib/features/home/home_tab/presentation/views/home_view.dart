import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_cubit.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_state.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/featured_hero_card.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_shimmer_loading.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/movies_horizontal_section.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final bgColor = isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: EdgeInsets.all(20.r),
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDarkColor : AppColors.borderLightColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.network(
                      movie.backdropUrl,
                      height: 180.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16.h),
                Text(
                  movie.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFBBF24),
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      movie.ratingFormatted,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      movie.releaseYear,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12.5.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  'Overview',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  movie.overview.isNotEmpty ? movie.overview : 'No overview available.',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    showComingSoon(context);
                  },
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: const Text('Watch Trailer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final cardColor = isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;
    final borderColor = isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

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
          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () => context.read<HomeCubit>().fetchHomeData(),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              children: [
                // Search Mock Bar (Matches Figma)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24.r),
                    onTap: () => showComingSoon(context),
                    child: Container(
                      height: 46.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: secondaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Search movies, actors, directors...',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 12.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                // Featured Hero Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FeaturedHeroCard(
                    movie: state.featuredMovie,
                    onDetails: () {
                      if (state.featuredMovie != null) {
                        _showMovieDetails(context, state.featuredMovie!);
                      }
                    },
                    onWatchTrailer: () => showComingSoon(context),
                  ),
                ),

                SizedBox(height: 24.h),

                // Trending Section
                MoviesHorizontalSection(
                  title: 'Trending Today',
                  movies: state.trendingMovies,
                  onSeeAll: () => showComingSoon(context),
                  onMovieTap: (movie) => _showMovieDetails(context, movie),
                ),

                SizedBox(height: 24.h),

                // Popular Section
                MoviesHorizontalSection(
                  title: 'Popular on MovieVerse',
                  movies: state.popularMovies,
                  onSeeAll: () => showComingSoon(context),
                  onMovieTap: (movie) => _showMovieDetails(context, movie),
                ),

                SizedBox(height: 24.h),

                // Top Rated Section
                MoviesHorizontalSection(
                  title: 'Top Rated Classics',
                  movies: state.topRatedMovies,
                  onSeeAll: () => showComingSoon(context),
                  onMovieTap: (movie) => _showMovieDetails(context, movie),
                ),

                SizedBox(height: 24.h),

                // Now Playing in Theaters
                MoviesHorizontalSection(
                  title: 'Now in Theaters',
                  movies: state.nowPlayingMovies,
                  onSeeAll: () => showComingSoon(context),
                  onMovieTap: (movie) => _showMovieDetails(context, movie),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

