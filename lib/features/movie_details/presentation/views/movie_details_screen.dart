import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/app_toast.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_cubit.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_state.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_backdrop_header.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_cast_section.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_shimmer_loading.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_info_section.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_overview_section.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_similar_section.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailsCubit>(
      create: (_) => getIt<MovieDetailsCubit>()..fetchMovieDetails(movieId),
      child: const _MovieDetailsView(),
    );
  }
}

class _MovieDetailsView extends StatefulWidget {
  const _MovieDetailsView();

  @override
  State<_MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<_MovieDetailsView> {
  bool _isBookmarked = false;

  void _onPlayTrailer(BuildContext context, MovieDetails movie) {
    if (movie.trailerKey != null && movie.trailerKey!.isNotEmpty) {
      _showTrailerDialog(context, movie);
    } else {
      showComingSoon(context);
    }
  }

  void _showTrailerDialog(BuildContext context, MovieDetails movie) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Trailer: ${movie.title}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YouTube Trailer Key:',
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryTextDarkColor
                      : AppColors.secondaryTextLightColor,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: SelectableText(
                  'https://www.youtube.com/watch?v=${movie.trailerKey}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const MovieDetailsShimmerLoading();
          }

          if (state is MovieDetailsError) {
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
                      onPressed: () {
                        final movieId =
                            (context.findAncestorWidgetOfExactType<MovieDetailsScreen>())
                                ?.movieId;
                        if (movieId != null) {
                          context
                              .read<MovieDetailsCubit>()
                              .fetchMovieDetails(movieId);
                        }
                      },
                      child: const Text('Try Again'),
                    ),
                    SizedBox(height: 10.h),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            final movie = state.movieDetails;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Backdrop Hero Header with Back and Bookmark buttons
                  MovieBackdropHeader(
                    movie: movie,
                    isBookmarked: _isBookmarked,
                    onBack: () => Navigator.pop(context),
                    onBookmark: () {
                      setState(() {
                        _isBookmarked = !_isBookmarked;
                      });
                      AppToast.success(
                        context,
                        message: _isBookmarked
                            ? 'Added to your Watchlist'
                            : 'Removed from Watchlist',
                      );
                    },
                    onPlayTrailer: () => _onPlayTrailer(context, movie),
                  ),

                  // Floating Info, Badges, Poster, Genres and Watch Button
                  MovieInfoSection(
                    movie: movie,
                    onWatchTrailer: () => _onPlayTrailer(context, movie),
                  ),

                  SizedBox(height: 24.h),

                  // Storyline / Synopsis
                  MovieOverviewSection(overview: movie.overview),

                  SizedBox(height: 24.h),

                  // Top Cast
                  MovieCastSection(cast: movie.cast),

                  SizedBox(height: 24.h),

                  // Similar Movies (More Like This)
                  MovieSimilarSection(
                    movies: movie.similarMovies,
                    onMovieTap: (similar) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => MovieDetailsScreen(movieId: similar.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
