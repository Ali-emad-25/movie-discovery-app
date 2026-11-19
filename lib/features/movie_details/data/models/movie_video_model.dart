import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_video.dart';

class MovieVideoModel extends MovieVideo {
  const MovieVideoModel({
    required super.id,
    required super.name,
    required super.key,
    required super.site,
    required super.type,
    super.official = true,
    super.publishedAt,
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) {
    return MovieVideoModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      key: json['key'] as String? ?? '',
      site: json['site'] as String? ?? '',
      type: json['type'] as String? ?? 'Trailer',
      official: json['official'] as bool? ?? true,
      publishedAt: json['published_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'key': key,
      'site': site,
      'type': type,
      'official': official,
      'published_at': publishedAt,
    };
  }
}

