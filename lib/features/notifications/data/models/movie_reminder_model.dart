import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';

class MovieReminderModel extends MovieReminder {
  const MovieReminderModel({
    required super.id,
    required super.movieId,
    required super.title,
    super.posterPath,
    required super.releaseDate,
    required super.scheduledTime,
    required super.createdAt,
  });

  factory MovieReminderModel.fromMap(Map<String, dynamic> map) {
    return MovieReminderModel(
      id: map['id'] as int? ?? 0,
      movieId: map['movie_id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      posterPath: map['poster_path'] as String?,
      releaseDate: map['release_date'] as String? ?? '',
      scheduledTime: DateTime.parse(map['scheduled_time'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'movie_id': movieId,
      'title': title,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'scheduled_time': scheduledTime.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
