import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';

sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  final List<MovieReminder> reminders;
  final NotificationSettings settings;

  const NotificationsLoaded(
    this.reminders, {
    this.settings = const NotificationSettings(),
  });

  bool isReminderSet(int movieId) =>
      reminders.any((r) => r.movieId == movieId);

  NotificationsLoaded copyWith({
    List<MovieReminder>? reminders,
    NotificationSettings? settings,
  }) {
    return NotificationsLoaded(
      reminders ?? this.reminders,
      settings: settings ?? this.settings,
    );
  }
}

final class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);
}
