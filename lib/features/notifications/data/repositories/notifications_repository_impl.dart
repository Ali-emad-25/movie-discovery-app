import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/core/services/notification_service.dart';
import 'package:movie_discovery_app/features/notifications/data/data_sources/notifications_local_data_source.dart';
import 'package:movie_discovery_app/features/notifications/data/models/movie_reminder_model.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';
import 'package:movie_discovery_app/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsLocalDataSource localDataSource;
  final NotificationService notificationService;

  const NotificationsRepositoryImpl({
    required this.localDataSource,
    required this.notificationService,
  });

  @override
  Future<ApiResult<List<MovieReminder>>> getReminders() async {
    try {
      final reminders = await localDataSource.getReminders();
      return ApiSuccess(reminders);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<MovieReminder>> scheduleReminder({
    required int movieId,
    required String title,
    String? posterPath,
    required String releaseDate,
    required DateTime scheduledTime,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    try {
      final existing = await localDataSource.getReminderByMovieId(movieId);
      if (existing != null) {
        await notificationService.cancelReminder(existing.id);
      }

      final inserted = await localDataSource.insertReminder(
        MovieReminderModel(
          id: 0,
          movieId: movieId,
          title: title,
          posterPath: posterPath,
          releaseDate: releaseDate,
          scheduledTime: scheduledTime,
          createdAt: DateTime.now(),
        ),
      );

      final settings = await localDataSource.getNotificationSettings();
      if (settings.remindersEnabled) {
        await notificationService.scheduleReminder(
          notificationId: inserted.id,
          title: notificationTitle,
          body: notificationBody,
          scheduledDate: scheduledTime,
          movieId: movieId,
        );
      }

      return ApiSuccess(inserted);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> cancelReminder(int movieId) async {
    try {
      final existing = await localDataSource.getReminderByMovieId(movieId);
      if (existing != null) {
        await notificationService.cancelReminder(existing.id);
        await localDataSource.deleteReminderByMovieId(movieId);
      }
      return const ApiSuccess(null);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> clearAllReminders() async {
    try {
      await notificationService.cancelAllReminders();
      await localDataSource.clearAllReminders();
      return const ApiSuccess(null);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<NotificationSettings>> getNotificationSettings() async {
    try {
      final settings = await localDataSource.getNotificationSettings();
      return ApiSuccess(settings);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> saveNotificationSettings(
    NotificationSettings settings, {
    String? notificationTitleSuffix,
    String? notificationBody,
  }) async {
    try {
      await localDataSource.saveNotificationSettings(settings);
      if (!settings.remindersEnabled) {
        await notificationService.cancelAllReminders();
      } else {
        final reminders = await localDataSource.getReminders();
        for (final r in reminders) {
          if (r.scheduledTime.isAfter(DateTime.now())) {
            await notificationService.scheduleReminder(
              notificationId: r.id,
              title: notificationTitleSuffix != null
                  ? '${r.title} — $notificationTitleSuffix'
                  : r.title,
              body: notificationBody ?? r.releaseDate,
              scheduledDate: r.scheduledTime,
              movieId: r.movieId,
            );
          }
        }
      }
      return const ApiSuccess(null);
    } catch (e) {
      return ApiError(DatabaseFailure(e.toString()));
    }
  }
}
