import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';

class SearchItemModel extends SearchItem {
  const SearchItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imagePath,
    required super.releaseDate,
    required super.rating,
    required super.popularity,
    required super.genreIds,
    required super.type,
  });

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    final type = switch (json['media_type']) {
      'tv' => SearchItemType.tv,
      'person' => SearchItemType.person,
      _ => SearchItemType.movie,
    };
    final titleValue = type == SearchItemType.person
        ? json['name']
        : json['title'] ?? json['name'];
    final imageValue = type == SearchItemType.person
        ? json['profile_path']
        : json['poster_path'];
    final dateValue = type == SearchItemType.tv
        ? json['first_air_date']
        : json['release_date'];
    final genres = json['genre_ids'] as List<dynamic>? ?? const [];

    return SearchItemModel(
      id: json['id'] as int? ?? 0,
      title: titleValue as String? ?? '',
      description: type == SearchItemType.person
          ? json['known_for_department'] as String? ?? ''
          : json['overview'] as String? ?? '',
      imagePath: imageValue as String?,
      releaseDate: dateValue as String? ?? '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      genreIds: genres.whereType<num>().map((value) => value.toInt()).toList(),
      type: type,
    );
  }
}
