class MovieVideo {
  final String id;
  final String name;
  final String key;
  final String site;
  final String type;
  final bool official;
  final String? publishedAt;

  const MovieVideo({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
    required this.type,
    this.official = true,
    this.publishedAt,
  });

  String get youtubeThumbnailUrl =>
      'https://img.youtube.com/vi/$key/hqdefault.jpg';

  String get thumbnailUrl => youtubeThumbnailUrl;

  String get youtubeVideoUrl => 'https://www.youtube.com/watch?v=$key';
}

