import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_model.dart';

class MovieResponseModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  const MovieResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? defaultMediaType,
  }) {
    return MovieResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                (e) => MovieModel.fromJson(
                  e as Map<String, dynamic>,
                  defaultMediaType: defaultMediaType,
                ),
              )
              .toList() ??
          const [],
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}

