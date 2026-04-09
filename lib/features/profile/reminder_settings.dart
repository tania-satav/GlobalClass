class ReminderSettings {
  final bool remindersEnabled;
  final int frequencyHours;
  final String startTime;
  final String endTime;
  final String quietStart;
  final String quietEnd;

  const ReminderSettings({
    required this.remindersEnabled,
    required this.frequencyHours,
    required this.startTime,
    required this.endTime,
    required this.quietStart,
    required this.quietEnd,
  });

  factory ReminderSettings.defaults() {
    return const ReminderSettings(
      remindersEnabled: true,
      frequencyHours: 2,
      startTime: '09:00',
      endTime: '22:00',
      quietStart: '23:00',
      quietEnd: '07:00',
    );
  }

  ReminderSettings copyWith({
    bool? remindersEnabled,
    int? frequencyHours,
    String? startTime,
    String? endTime,
    String? quietStart,
    String? quietEnd,
  }) {
    return ReminderSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      frequencyHours: frequencyHours ?? this.frequencyHours,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
    );
  }
}