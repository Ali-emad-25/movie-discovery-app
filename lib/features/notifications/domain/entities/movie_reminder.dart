/// Pure domain entity representing a saved release reminder.
class MovieReminder {
  final int id;
  final int movieId;
  final String title;
  final String? posterPath;
  final String releaseDate;
  final DateTime scheduledTime;
  final DateTime createdAt;

  const MovieReminder({
    required this.id,
    required this.movieId,
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.scheduledTime,
    required this.createdAt,
  });

  String get posterUrl =>
      posterPath != null && posterPath!.isNotEmpty
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : '';
}
