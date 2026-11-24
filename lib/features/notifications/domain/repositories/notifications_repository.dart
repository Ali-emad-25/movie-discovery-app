import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';

abstract class NotificationsRepository {
  Future<ApiResult<List<MovieReminder>>> getReminders();

  Future<ApiResult<MovieReminder>> scheduleReminder({
    required int movieId,
    required String title,
    String? posterPath,
    required String releaseDate,
    required DateTime scheduledTime,
    required String notificationTitle,
    required String notificationBody,
  });

  Future<ApiResult<void>> cancelReminder(int movieId);

  Future<ApiResult<void>> clearAllReminders();

  Future<ApiResult<NotificationSettings>> getNotificationSettings();

  Future<ApiResult<void>> saveNotificationSettings(
    NotificationSettings settings, {
    String? notificationTitleSuffix,
    String? notificationBody,
  });
}
