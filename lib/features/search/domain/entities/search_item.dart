import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

enum SearchItemType { movie, tv, person }

class SearchItem {
  final int id;
  final String title;
  final String description;
  final String? imagePath;
  final String releaseDate;
  final double rating;
  final double popularity;
  final List<int> genreIds;
  final SearchItemType type;

  const SearchItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.releaseDate,
    required this.rating,
    required this.popularity,
    required this.genreIds,
    required this.type,
  });

  String get imageUrl => imagePath == null || imagePath!.isEmpty
      ? ''
      : 'https://image.tmdb.org/t/p/w500$imagePath';

  int? get year => releaseDate.length >= 4
      ? int.tryParse(releaseDate.substring(0, 4))
      : null;

  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: description,
      posterPath: imagePath,
      backdropPath: null,
      voteAverage: rating,
      releaseDate: releaseDate,
      genreIds: genreIds,
      mediaType: type == SearchItemType.tv ? 'tv' : 'movie',
    );
  }
}
