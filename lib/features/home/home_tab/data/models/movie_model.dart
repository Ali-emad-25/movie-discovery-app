import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genreIds,
    super.mediaType = 'movie',
  });

  factory MovieModel.fromJson(
    Map<String, dynamic> json, {
    String? defaultMediaType,
  }) {
    final mediaType = json['media_type'] as String? ??
        defaultMediaType ??
        (json['first_air_date'] != null || json['name'] != null
            ? 'tv'
            : 'movie');

    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String? ??
          json['first_air_date'] as String? ??
          '',
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      mediaType: mediaType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'media_type': mediaType,
    };
  }
}

