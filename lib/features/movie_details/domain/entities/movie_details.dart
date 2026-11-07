import 'package:movie_discovery_app/core/network/api_constants.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/cast.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_video.dart';

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
  final String tagline;
  final String? trailerKey;
  final List<Cast> cast;
  final List<Movie> similarMovies;
  final List<MovieVideo> videos;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.tagline,
    this.trailerKey,
    this.cast = const [],
    this.similarMovies = const [],
    this.videos = const [],
  });

  String get posterUrl => posterPath != null && posterPath!.isNotEmpty
      ? '${ApiConstants.imageBaseUrlW500}$posterPath'
      : '';

  String get backdropUrl => backdropPath != null && backdropPath!.isNotEmpty
      ? '${ApiConstants.imageBaseUrlOriginal}$backdropPath'
      : '';

  String get releaseYear =>
      releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';

  String get ratingFormatted => voteAverage.toStringAsFixed(1);

  String get formattedRuntime {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
