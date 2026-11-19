import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_cubit.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_state.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/in_app_trailer_player.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_cast_section.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_action_buttons.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_app_bar.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_bento_grid.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_header_block.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_hero.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_segmented_tabs.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_details_shimmer_loading.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_similar_section.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/movie_storyline_card.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/trailers_section.dart';

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
  int _selectedTabIndex = 0;
  bool _isFavorite = false;

  void _onPlayTrailer(BuildContext context, MovieDetails movie) {
    if (movie.trailerKey != null && movie.trailerKey!.isNotEmpty) {
      InAppTrailerPlayer.show(
        context: context,
        videoKey: movie.trailerKey!,
        title: '${movie.title} - Official Trailer',
      );
    } else {
      Fluttertoast.showToast(
        msg: 'movie_details.no_trailers'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: const Color(0xFF171B26),
        textColor: Colors.white,
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    Fluttertoast.showToast(
      msg: _isFavorite
          ? (context.locale.languageCode == 'ar'
              ? 'تمت الإضافة إلى المفضلة'
              : 'Added to Favorites')
          : (context.locale.languageCode == 'ar'
              ? 'تمت الإزالة من المفضلة'
              : 'Removed from Favorites'),
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F131D) : const Color(0xFFF8FAFC);
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;

    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        if (state is MovieDetailsLoading) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const MovieDetailsShimmerLoading(),
          );
        }

        if (state is MovieDetailsError) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white : AppColors.textLightColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
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
                        final movieId = (context
                                .findAncestorWidgetOfExactType<MovieDetailsScreen>())
                            ?.movieId;
                        if (movieId != null) {
                          context
                              .read<MovieDetailsCubit>()
                              .fetchMovieDetails(movieId);
                        }
                      },
                      child: Text('common.retry'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is MovieDetailsLoaded) {
          final movie = state.movieDetails;

          return Scaffold(
            backgroundColor: bgColor,
            appBar: MovieDetailsAppBar(
              movieTitle: movie.title,
              onBack: () => Navigator.pop(context),
            ),
            body: ListView(
              padding: EdgeInsets.only(bottom: 32.h),
              children: [
                // 1. Hero Section with Cinematic Backdrop (16/10)
                MovieDetailsHero(
                  movie: movie,
                  isFavorite: _isFavorite,
                  onToggleFavorite: _toggleFavorite,
                  onPlayTrailer: () => _onPlayTrailer(context, movie),
                ),

                SizedBox(height: 16.h),

                // 2. Title & Live Score Header Block
                MovieDetailsHeaderBlock(movie: movie),

                SizedBox(height: 16.h),

                // 3. Primary Action Buttons (Add to Watchlist, Watched, Rate)
                const MovieDetailsActionButtons(),

                SizedBox(height: 18.h),

                // 4. Interactive Segmented Tabs (Overview, Cast, Trailers, Similar)
                MovieDetailsSegmentedTabs(
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),

                SizedBox(height: 20.h),

                // 5. Tab Content
                if (_selectedTabIndex == 0) ...[
                  // Overview Tab Content
                  MovieStorylineCard(overview: movie.overview),
                  SizedBox(height: 20.h),
                  MovieCastSection(cast: movie.cast),
                  SizedBox(height: 20.h),
                  TrailersSection(movie: movie),
                  SizedBox(height: 20.h),
                  MovieDetailsBentoGrid(movie: movie),
                ] else if (_selectedTabIndex == 1) ...[
                  // Cast Tab Content
                  MovieCastSection(cast: movie.cast),
                ] else if (_selectedTabIndex == 2) ...[
                  // Trailers Tab Content
                  TrailersSection(movie: movie),
                ] else if (_selectedTabIndex == 3) ...[
                  // Similar Movies Tab Content
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
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
