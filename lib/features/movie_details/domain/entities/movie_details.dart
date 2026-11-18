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
  final int budget;
  final int revenue;
  final String director;
  final String musicComposer;
  final String? collectionName;

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
    this.budget = 0,
    this.revenue = 0,
    this.director = '',
    this.musicComposer = '',
    this.collectionName,
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

  String formattedRuntime([String languageCode = 'en']) {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (languageCode == 'ar') {
      if (hours == 0) return '$minutes د';
      if (minutes == 0) return '$hours س';
      return '$hours س $minutes د';
    }
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  String get runtimeFormatted => formattedRuntime('en');

  String formattedCurrency(int amount, String languageCode) {
    if (amount <= 0) {
      return languageCode == 'ar' ? 'غير متوفر' : 'N/A';
    }
    if (amount >= 1000000000) {
      final val = (amount / 1000000000).toStringAsFixed(1);
      return languageCode == 'ar' ? '\$$val مليار' : '\$$val Billion';
    }
    if (amount >= 1000000) {
      final val = (amount / 1000000).toStringAsFixed(1);
      return languageCode == 'ar' ? '\$$val مليون' : '\$$val Million';
    }
    if (amount >= 1000) {
      final val = (amount / 1000).toStringAsFixed(0);
      return languageCode == 'ar' ? '\$$val ألف' : '\$$val K';
    }
    return '\$$amount';
  }
}
