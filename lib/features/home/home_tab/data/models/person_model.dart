import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    super.profilePath,
    super.knownForDepartment,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'known_for_department': knownForDepartment,
    };
  }
}

class PersonResponseModel {
  final int page;
  final List<PersonModel> results;
  final int totalPages;
  final int totalResults;

  const PersonResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PersonResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => PersonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}

