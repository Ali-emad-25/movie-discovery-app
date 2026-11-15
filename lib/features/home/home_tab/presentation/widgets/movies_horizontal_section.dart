import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_section_header.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/movie_card.dart';

class MoviesHorizontalSection extends StatelessWidget {
  final String title;
  final Color accentColor;
  final List<Movie> movies;
  final VoidCallback? onSeeAll;
  final void Function(Movie movie)? onMovieTap;

  const MoviesHorizontalSection({
    super.key,
    required this.title,
    required this.accentColor,
    required this.movies,
    this.onSeeAll,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with colored accent bar
        HomeSectionHeader(
          title: title,
          accentColor: accentColor,
          onSeeAll: onSeeAll,
        ),

        SizedBox(height: 12.h),

        // Movies Horizontal List
        SizedBox(
          height: 235.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => onMovieTap?.call(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}
