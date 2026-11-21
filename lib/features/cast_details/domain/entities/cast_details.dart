class CastDetails {
  final int id;
  final String name;
  final String? profilePath;
  final String department;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;
  final List<CastCredit> movieCredits;
  final List<CastCredit> tvCredits;

  const CastDetails({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.department,
    required this.biography,
    required this.birthday,
    required this.placeOfBirth,
    required this.movieCredits,
    required this.tvCredits,
  });

  String get profileUrl => _imageUrl(profilePath);

  List<CastCredit> get knownFor =>
      [...movieCredits, ...tvCredits]
        ..sort((a, b) => b.popularity.compareTo(a.popularity));

  int? get age {
    final birthDate = DateTime.tryParse(birthday ?? '');
    if (birthDate == null) return null;
    final now = DateTime.now();
    var years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }
}

class CastCredit {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final String character;
  final double rating;
  final double popularity;

  const CastCredit({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.character,
    required this.rating,
    required this.popularity,
  });

  String get posterUrl => _imageUrl(posterPath);

  int? get year {
    final date = releaseDate ?? '';
    return date.length >= 4 ? int.tryParse(date.substring(0, 4)) : null;
  }
}

String _imageUrl(String? path) =>
    path == null || path.isEmpty ? '' : 'https://image.tmdb.org/t/p/w500$path';
