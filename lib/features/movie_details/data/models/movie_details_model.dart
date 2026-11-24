import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_model.dart';
import 'package:movie_discovery_app/features/movie_details/data/models/cast_model.dart';
import 'package:movie_discovery_app/features/movie_details/data/models/movie_video_model.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    required super.tagline,
    super.trailerKey,
    super.cast = const [],
    super.similarMovies = const [],
    super.videos = const [],
    super.budget = 0,
    super.revenue = 0,
    super.director = '',
    super.musicComposer = '',
    super.collectionName,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    // Parse genres
    final genresList = (json['genres'] as List<dynamic>?)
            ?.map((g) => (g as Map<String, dynamic>)['name'] as String? ?? '')
            .where((name) => name.isNotEmpty)
            .toList() ??
        const [];

    // Parse cast and crew
    final creditsJson = json['credits'] as Map<String, dynamic>?;
    final castJson = creditsJson != null
        ? creditsJson['cast'] as List<dynamic>?
        : null;
    final castList = castJson
            ?.map((c) => CastModel.fromJson(c as Map<String, dynamic>))
            .toList() ??
        const [];

    String director = '';
    String musicComposer = '';
    final crewJson = creditsJson != null
        ? creditsJson['crew'] as List<dynamic>?
        : null;
    if (crewJson != null) {
      for (final member in crewJson) {
        final m = member as Map<String, dynamic>;
        final job = m['job'] as String? ?? '';
        final name = m['name'] as String? ?? '';
        if (job == 'Director' && director.isEmpty) {
          director = name;
        } else if ((job == 'Original Music Composer' || job == 'Music') &&
            musicComposer.isEmpty) {
          musicComposer = name;
        }
      }
    }

    if (director.isEmpty &&
        json['created_by'] is List &&
        (json['created_by'] as List).isNotEmpty) {
      director = (json['created_by'] as List).first['name'] as String? ?? '';
    }

    // Parse collection
    String? collectionName;
    if (json['belongs_to_collection'] != null) {
      collectionName = (json['belongs_to_collection']
          as Map<String, dynamic>)['name'] as String?;
    }

    // Parse similar movies
    final similarJson = json['similar'] != null
        ? (json['similar'] as Map<String, dynamic>)['results'] as List<dynamic>?
        : null;
    final similarList = similarJson
            ?.map((m) => MovieModel.fromJson(m as Map<String, dynamic>))
            .toList() ??
        const [];

    // Parse official trailers
    final List<MovieVideoModel> videosList = [];
    String? trailerKey;
    final videosJson = json['videos'] != null
        ? (json['videos'] as Map<String, dynamic>)['results'] as List<dynamic>?
        : null;
    if (videosJson != null && videosJson.isNotEmpty) {
      // 1. Official YouTube Trailers
      for (final v in videosJson) {
        final videoMap = v as Map<String, dynamic>;
        final site = videoMap['site'] as String?;
        final type = videoMap['type'] as String?;
        final official = videoMap['official'] as bool? ?? false;
        if (site == 'YouTube' && type == 'Trailer' && official) {
          videosList.add(MovieVideoModel.fromJson(videoMap));
        }
      }

      // 2. Fallback: Any YouTube Trailer
      if (videosList.isEmpty) {
        for (final v in videosJson) {
          final videoMap = v as Map<String, dynamic>;
          final site = videoMap['site'] as String?;
          final type = videoMap['type'] as String?;
          if (site == 'YouTube' && type == 'Trailer') {
            videosList.add(MovieVideoModel.fromJson(videoMap));
          }
        }
      }

      // 3. Fallback: Teasers
      if (videosList.isEmpty) {
        for (final v in videosJson) {
          final videoMap = v as Map<String, dynamic>;
          final site = videoMap['site'] as String?;
          final type = videoMap['type'] as String?;
          if (site == 'YouTube' && type == 'Teaser') {
            videosList.add(MovieVideoModel.fromJson(videoMap));
          }
        }
      }

      trailerKey = videosList.isNotEmpty ? videosList.first.key : null;
    }

    return MovieDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: json['release_date'] as String? ??
          json['first_air_date'] as String? ??
          '',
      runtime: (json['runtime'] as int?) ??
          ((json['episode_run_time'] as List<dynamic>?)?.isNotEmpty == true
              ? (json['episode_run_time'] as List<dynamic>).first as int
              : 0),
      genres: genresList,
      tagline: json['tagline'] as String? ?? '',
      trailerKey: trailerKey,
      cast: castList,
      similarMovies: similarList,
      videos: videosList,
      budget: json['budget'] as int? ?? 0,
      revenue: json['revenue'] as int? ?? 0,
      director: director,
      musicComposer: musicComposer,
      collectionName: collectionName,
    );
  }
}
