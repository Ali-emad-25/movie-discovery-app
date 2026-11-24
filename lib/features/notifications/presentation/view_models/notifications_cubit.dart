import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';
import 'package:movie_discovery_app/features/notifications/domain/use_cases/notifications_use_cases.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetRemindersUseCase getRemindersUseCase;
  final ScheduleReminderUseCase scheduleReminderUseCase;
  final CancelReminderUseCase cancelReminderUseCase;
  final ClearAllRemindersUseCase clearAllRemindersUseCase;
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  final SaveNotificationSettingsUseCase saveNotificationSettingsUseCase;

  NotificationsCubit({
    required this.getRemindersUseCase,
    required this.scheduleReminderUseCase,
    required this.cancelReminderUseCase,
    required this.clearAllRemindersUseCase,
    required this.getNotificationSettingsUseCase,
    required this.saveNotificationSettingsUseCase,
  }) : super(const NotificationsInitial());

  List<MovieReminder> get _currentReminders => switch (state) {
        NotificationsLoaded(:final reminders) => reminders,
        _ => const [],
      };

  NotificationSettings get _currentSettings => switch (state) {
        NotificationsLoaded(:final settings) => settings,
        _ => const NotificationSettings(),
      };

  Future<void> loadReminders() async {
    emit(const NotificationsLoading());
    final results = await Future.wait([
      getRemindersUseCase(),
      getNotificationSettingsUseCase(),
    ]);

    final remindersResult = results[0] as ApiResult<List<MovieReminder>>;
    final settingsResult = results[1] as ApiResult<NotificationSettings>;

    final settings = switch (settingsResult) {
      ApiSuccess(:final data) => data,
      ApiError() => const NotificationSettings(),
    };

    switch (remindersResult) {
      case ApiSuccess(:final data):
        emit(NotificationsLoaded(data, settings: settings));
      case ApiError(:final failure):
        emit(NotificationsError(failure.message));
    }
  }

  /// Toggles a release reminder for [movieId]. Returns `true` if scheduled, `false` if cancelled,
  /// or `null` if an error occurred.
  Future<bool?> toggleReminder({
    required int movieId,
    required String title,
    String? posterPath,
    required String releaseDate,
    required String notificationTitle,
    required String notificationBody,
    DateTime? customScheduledTime,
  }) async {
    final currentlySet = _currentReminders.any((r) => r.movieId == movieId);

    if (currentlySet) {
      final result = await cancelReminderUseCase(movieId);
      switch (result) {
        case ApiSuccess():
          final updated =
              _currentReminders.where((r) => r.movieId != movieId).toList();
          emit(NotificationsLoaded(updated, settings: _currentSettings));
          return false;
        case ApiError(:final failure):
          emit(NotificationsError(failure.message));
          return null;
      }
    }

    final scheduledTime = customScheduledTime ??
        _computeDefaultScheduledTime(releaseDate, _currentSettings.defaultTiming);

    final result = await scheduleReminderUseCase(
      movieId: movieId,
      title: title,
      posterPath: posterPath,
      releaseDate: releaseDate,
      scheduledTime: scheduledTime,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    );

    switch (result) {
      case ApiSuccess(:final data):
        final updated = [..._currentReminders, data]
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
        emit(NotificationsLoaded(updated, settings: _currentSettings));
        return true;
      case ApiError(:final failure):
        emit(NotificationsError(failure.message));
        return null;
    }
  }

  Future<void> cancelReminder(int movieId) async {
    final result = await cancelReminderUseCase(movieId);
    switch (result) {
      case ApiSuccess():
        final updated =
            _currentReminders.where((r) => r.movieId != movieId).toList();
        emit(NotificationsLoaded(updated, settings: _currentSettings));
      case ApiError(:final failure):
        emit(NotificationsError(failure.message));
    }
  }

  Future<void> clearAllReminders() async {
    final result = await clearAllRemindersUseCase();
    switch (result) {
      case ApiSuccess():
        emit(NotificationsLoaded(const [], settings: _currentSettings));
      case ApiError(:final failure):
        emit(NotificationsError(failure.message));
    }
  }

  Future<void> rescheduleMovie({
    required MovieReminder reminder,
    required DateTime newScheduledTime,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    final result = await scheduleReminderUseCase(
      movieId: reminder.movieId,
      title: reminder.title,
      posterPath: reminder.posterPath,
      releaseDate: reminder.releaseDate,
      scheduledTime: newScheduledTime,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    );

    switch (result) {
      case ApiSuccess(:final data):
        final updated = _currentReminders
            .map((r) => r.movieId == data.movieId ? data : r)
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
        emit(NotificationsLoaded(updated, settings: _currentSettings));
      case ApiError(:final failure):
        emit(NotificationsError(failure.message));
    }
  }

  Future<void> updateSettings(
    NotificationSettings newSettings, {
    String? notificationTitleSuffix,
    String? notificationBody,
  }) async {
    final previousTiming = _currentSettings.defaultTiming;
    var reminders = _currentReminders;
    emit(NotificationsLoaded(reminders, settings: newSettings));

    final result = await saveNotificationSettingsUseCase(
      newSettings,
      notificationTitleSuffix: notificationTitleSuffix,
      notificationBody: notificationBody,
    );

    if (result case ApiError(:final failure)) {
      emit(NotificationsError(failure.message));
      return;
    }

    // If default timing changed, update & reschedule existing reminders to match
    if (previousTiming != newSettings.defaultTiming && reminders.isNotEmpty) {
      final updatedList = <MovieReminder>[];
      for (final r in reminders) {
        final newTime = _computeDefaultScheduledTime(
          r.releaseDate,
          newSettings.defaultTiming,
        );
        final res = await scheduleReminderUseCase(
          movieId: r.movieId,
          title: r.title,
          posterPath: r.posterPath,
          releaseDate: r.releaseDate,
          scheduledTime: newTime,
          notificationTitle: notificationTitleSuffix != null
              ? '${r.title} — $notificationTitleSuffix'
              : r.title,
          notificationBody: notificationBody ?? r.releaseDate,
        );
        switch (res) {
          case ApiSuccess(:final data):
            updatedList.add(data);
          case ApiError():
            updatedList.add(r);
        }
      }
      updatedList.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
      emit(NotificationsLoaded(updatedList, settings: newSettings));
    }
  }

  DateTime _computeDefaultScheduledTime(
    String releaseDate,
    ReminderTiming timing,
  ) {
    final parsed = DateTime.tryParse(releaseDate);
    final now = DateTime.now();
    if (parsed != null) {
      final targetDay = timing == ReminderTiming.oneDayBefore
          ? parsed.subtract(const Duration(days: 1))
          : parsed;
      final scheduled = DateTime(
        targetDay.year,
        targetDay.month,
        targetDay.day,
        10,
      );
      if (scheduled.isAfter(now)) {
        return scheduled;
      }
    }
    return now.add(const Duration(seconds: 10));
  }
}
