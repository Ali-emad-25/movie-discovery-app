import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';
import 'package:movie_discovery_app/features/notifications/domain/repositories/notifications_repository.dart';

class GetRemindersUseCase {
  final NotificationsRepository repository;

  const GetRemindersUseCase(this.repository);

  Future<ApiResult<List<MovieReminder>>> call() {
    return repository.getReminders();
  }
}

class ScheduleReminderUseCase {
  final NotificationsRepository repository;

  const ScheduleReminderUseCase(this.repository);

  Future<ApiResult<MovieReminder>> call({
    required int movieId,
    required String title,
    String? posterPath,
    required String releaseDate,
    required DateTime scheduledTime,
    required String notificationTitle,
    required String notificationBody,
  }) {
    return repository.scheduleReminder(
      movieId: movieId,
      title: title,
      posterPath: posterPath,
      releaseDate: releaseDate,
      scheduledTime: scheduledTime,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    );
  }
}

class CancelReminderUseCase {
  final NotificationsRepository repository;

  const CancelReminderUseCase(this.repository);

  Future<ApiResult<void>> call(int movieId) {
    return repository.cancelReminder(movieId);
  }
}

class ClearAllRemindersUseCase {
  final NotificationsRepository repository;

  const ClearAllRemindersUseCase(this.repository);

  Future<ApiResult<void>> call() {
    return repository.clearAllReminders();
  }
}

class GetNotificationSettingsUseCase {
  final NotificationsRepository repository;

  const GetNotificationSettingsUseCase(this.repository);

  Future<ApiResult<NotificationSettings>> call() {
    return repository.getNotificationSettings();
  }
}

class SaveNotificationSettingsUseCase {
  final NotificationsRepository repository;

  const SaveNotificationSettingsUseCase(this.repository);

  Future<ApiResult<void>> call(
    NotificationSettings settings, {
    String? notificationTitleSuffix,
    String? notificationBody,
  }) {
    return repository.saveNotificationSettings(
      settings,
      notificationTitleSuffix: notificationTitleSuffix,
      notificationBody: notificationBody,
    );
  }
}
