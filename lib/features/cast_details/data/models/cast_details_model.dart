import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';

class CastDetailsModel extends CastDetails {
  const CastDetailsModel({
    required super.id,
    required super.name,
    required super.profilePath,
    required super.department,
    required super.biography,
    required super.birthday,
    required super.placeOfBirth,
    required super.movieCredits,
    required super.tvCredits,
  });

  factory CastDetailsModel.fromJson(Map<String, dynamic> json) {
    return CastDetailsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      department: json['known_for_department'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      birthday: json['birthday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      movieCredits: _creditsFrom(json['movie_credits'], isTv: false),
      tvCredits: _creditsFrom(json['tv_credits'], isTv: true),
    );
  }

  static List<CastCredit> _creditsFrom(dynamic value, {required bool isTv}) {
    if (value is! Map<String, dynamic> || value['cast'] is! List) {
      return const [];
    }
    return (value['cast'] as List)
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final date = isTv ? item['first_air_date'] : item['release_date'];
          return CastCredit(
            id: item['id'] as int? ?? 0,
            title:
                (isTv ? item['name'] : item['title'] ?? item['name'])
                    as String? ??
                '',
            posterPath: item['poster_path'] as String?,
            releaseDate: date as String?,
            character: item['character'] as String? ?? '',
            rating: (item['vote_average'] as num?)?.toDouble() ?? 0,
            popularity: (item['popularity'] as num?)?.toDouble() ?? 0,
          );
        })
        .where((credit) => credit.title.isNotEmpty)
        .toList();
  }
}
