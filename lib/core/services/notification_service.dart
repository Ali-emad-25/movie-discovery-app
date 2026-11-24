import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Handles local notification initialization, scheduling, cancellation, and taps.
class NotificationService {
  static const _channelId = 'movie_reminders_channel';
  static const _channelName = 'Movie Release Reminders';
  static const _channelDescription =
      'Notifications for upcoming movie release reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialized = false;

  Future<void> init({GlobalKey<NavigatorState>? navigatorKey}) async {
    _navigatorKey = navigatorKey;
    if (_initialized) return;

    tz_data.initializeTimeZones();
    _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _requestPermissions();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _onNotificationResponse(NotificationResponse response) {
    final movieId = int.tryParse(response.payload ?? '');
    if (movieId == null) return;

    _navigatorKey?.currentState?.pushNamed(
      AppRoutes.movieDetailsRouteName,
      arguments: movieId,
    );
  }

  Future<void> scheduleReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required int movieId,
  }) async {
    if (!_initialized) {
      await init(navigatorKey: _navigatorKey);
    }

    final now = DateTime.now();
    final effectiveDate = scheduledDate.isAfter(now)
        ? scheduledDate
        : now.add(const Duration(seconds: 10));

    final tzDate =
        tz.TZDateTime.now(tz.local).add(effectiveDate.difference(now));

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _plugin.zonedSchedule(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: movieId.toString(),
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: movieId.toString(),
      );
    }
  }

  void _configureLocalTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    for (final location in tz.timeZoneDatabase.locations.values) {
      if (location.currentTimeZone.offset == offset) {
        tz.setLocalLocation(location);
        return;
      }
    }
  }

  Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(id: notificationId);
  }

  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }
}
