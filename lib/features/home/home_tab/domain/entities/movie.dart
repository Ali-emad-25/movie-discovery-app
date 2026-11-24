class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;
  final String mediaType;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    this.mediaType = 'movie',
  });

  bool get isTvShow => mediaType == 'tv';

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';

  String get releaseYear {
    if (releaseDate.isEmpty) return '';
    return releaseDate.split('-').first;
  }

  String get ratingFormatted => voteAverage.toStringAsFixed(1);
}

