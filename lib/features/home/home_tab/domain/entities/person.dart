class Person {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;

  const Person({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
  });

  String get profileUrl => profilePath != null && profilePath!.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : '';
}

