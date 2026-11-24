import 'package:movie_discovery_app/core/database/database_helper.dart';
import 'package:movie_discovery_app/features/notifications/data/models/movie_reminder_model.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

abstract class NotificationsLocalDataSource {
  Future<List<MovieReminderModel>> getReminders();
  Future<MovieReminderModel?> getReminderByMovieId(int movieId);
  Future<MovieReminderModel> insertReminder(MovieReminderModel reminder);
  Future<void> deleteReminderByMovieId(int movieId);
  Future<void> clearAllReminders();
  Future<NotificationSettings> getNotificationSettings();
  Future<void> saveNotificationSettings(NotificationSettings settings);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  static const _remindersEnabledKey = 'notif_reminders_enabled';
  static const _defaultTimingKey = 'notif_default_timing';

  final DatabaseHelper databaseHelper;

  const NotificationsLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<MovieReminderModel>> getReminders() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.remindersTable,
      orderBy: 'scheduled_time ASC',
    );
    return maps.map(MovieReminderModel.fromMap).toList();
  }

  @override
  Future<MovieReminderModel?> getReminderByMovieId(int movieId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.remindersTable,
      where: 'movie_id = ?',
      whereArgs: [movieId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return MovieReminderModel.fromMap(maps.first);
  }

  @override
  Future<MovieReminderModel> insertReminder(MovieReminderModel reminder) async {
    final db = await databaseHelper.database;
    final id = await db.insert(
      DatabaseHelper.remindersTable,
      reminder.toInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return MovieReminderModel(
      id: id,
      movieId: reminder.movieId,
      title: reminder.title,
      posterPath: reminder.posterPath,
      releaseDate: reminder.releaseDate,
      scheduledTime: reminder.scheduledTime,
      createdAt: reminder.createdAt,
    );
  }

  @override
  Future<void> deleteReminderByMovieId(int movieId) async {
    final db = await databaseHelper.database;
    await db.delete(
      DatabaseHelper.remindersTable,
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
  }

  @override
  Future<void> clearAllReminders() async {
    final db = await databaseHelper.database;
    await db.delete(DatabaseHelper.remindersTable);
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final timingName = prefs.getString(_defaultTimingKey);
    final timing = ReminderTiming.values.firstWhere(
      (e) => e.name == timingName,
      orElse: () => ReminderTiming.onReleaseDay,
    );

    return NotificationSettings(
      remindersEnabled: prefs.getBool(_remindersEnabledKey) ?? true,
      defaultTiming: timing,
    );
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersEnabledKey, settings.remindersEnabled);
    await prefs.setString(_defaultTimingKey, settings.defaultTiming.name);
  }
}
