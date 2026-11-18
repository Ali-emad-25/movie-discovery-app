import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_section_header.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/top_rated_card.dart';

class TopRatedSection extends StatelessWidget {
  final List<Movie> movies;
  final VoidCallback? onSeeAll;
  final void Function(Movie movie)? onMovieTap;
  final int maxItems;

  const TopRatedSection({
    super.key,
    required this.movies,
    this.onSeeAll,
    this.onMovieTap,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final displayMovies = movies.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'home.sections.top_rated'.tr(),
          accentColor: const Color(0xFFFF383C), // Red accent from Figma
          onSeeAll: onSeeAll,
        ),
        SizedBox(height: 8.h),
        ...displayMovies.map(
          (m) => TopRatedCard(
            movie: m,
            onTap: () => onMovieTap?.call(m),
          ),
        ),
      ],
    );
  }
}

