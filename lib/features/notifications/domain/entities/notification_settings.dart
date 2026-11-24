enum ReminderTiming {
  onReleaseDay,
  oneDayBefore,
}

/// Pure domain entity holding user notification preferences.
class NotificationSettings {
  final bool remindersEnabled;
  final ReminderTiming defaultTiming;

  const NotificationSettings({
    this.remindersEnabled = true,
    this.defaultTiming = ReminderTiming.onReleaseDay,
  });

  NotificationSettings copyWith({
    bool? remindersEnabled,
    ReminderTiming? defaultTiming,
  }) {
    return NotificationSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      defaultTiming: defaultTiming ?? this.defaultTiming,
    );
  }
}
