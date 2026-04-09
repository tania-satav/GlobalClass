import '../database/database_helper.dart';
import '../features/profile/hydration_settings.dart';
import '../features/profile/reminder_settings.dart';
import '../features/stats/hydration_history_state.dart';

class HydrationRepository {
  HydrationRepository._internal();

  static final HydrationRepository instance = HydrationRepository._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  String dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<Map<String, dynamic>?> getSettingsRow() async {
    return _databaseHelper.getSettings();
  }

  Future<int> loadDailyGoalMl() async {
    final settings = await _databaseHelper.getSettings();
    return (settings?['daily_goal_ml'] as int?) ?? 2100;
  }

  Future<HydrationSettings> loadHydrationSettings() async {
    final settingsRow = await _databaseHelper.getSettings();
    final settings = HydrationSettings.instance;

    settings.loadPersonalisation(
      weightKg: (settingsRow?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel:
          (settingsRow?['activity_level'] as String?) ?? 'Medium',
      unit: (settingsRow?['unit'] as String?) ?? 'ml',
      dailyGoalMl: (settingsRow?['daily_goal_ml'] as int?) ?? 2100,
    );

    return settings;
  }

  Future<void> saveHydrationSettings(HydrationSettings settings) async {
    final currentSettings = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: settings.weightKg,
      activityLevel: settings.activityLevel,
      unit: settings.unit,
      dailyGoalMl: settings.dailyGoalMl,
      lastOpenDate: currentSettings?['last_open_date'] as String?,
      remindersEnabled: (currentSettings?['reminders_enabled'] as int?) ?? 1,
      reminderFrequencyHours:
          (currentSettings?['reminder_frequency_hours'] as int?) ?? 2,
      reminderStartTime:
          (currentSettings?['reminder_start_time'] as String?) ?? '09:00',
      reminderEndTime:
          (currentSettings?['reminder_end_time'] as String?) ?? '22:00',
      quietStartTime:
          (currentSettings?['quiet_start_time'] as String?) ?? '23:00',
      quietEndTime:
          (currentSettings?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  Future<void> saveDailyGoalMl(int value) async {
    final currentSettings = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: (currentSettings?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel:
          (currentSettings?['activity_level'] as String?) ?? 'Medium',
      unit: (currentSettings?['unit'] as String?) ?? 'ml',
      dailyGoalMl: value,
      lastOpenDate: currentSettings?['last_open_date'] as String?,
      remindersEnabled: (currentSettings?['reminders_enabled'] as int?) ?? 1,
      reminderFrequencyHours:
          (currentSettings?['reminder_frequency_hours'] as int?) ?? 2,
      reminderStartTime:
          (currentSettings?['reminder_start_time'] as String?) ?? '09:00',
      reminderEndTime:
          (currentSettings?['reminder_end_time'] as String?) ?? '22:00',
      quietStartTime:
          (currentSettings?['quiet_start_time'] as String?) ?? '23:00',
      quietEndTime:
          (currentSettings?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  Future<ReminderSettings> loadReminderSettings() async {
    final settingsRow = await _databaseHelper.getSettings();

    return ReminderSettings(
      remindersEnabled: ((settingsRow?['reminders_enabled'] as int?) ?? 1) == 1,
      frequencyHours:
          (settingsRow?['reminder_frequency_hours'] as int?) ?? 2,
      startTime: (settingsRow?['reminder_start_time'] as String?) ?? '09:00',
      endTime: (settingsRow?['reminder_end_time'] as String?) ?? '22:00',
      quietStart: (settingsRow?['quiet_start_time'] as String?) ?? '23:00',
      quietEnd: (settingsRow?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  Future<void> saveReminderSettings(ReminderSettings reminderSettings) async {
    final currentSettings = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: (currentSettings?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel:
          (currentSettings?['activity_level'] as String?) ?? 'Medium',
      unit: (currentSettings?['unit'] as String?) ?? 'ml',
      dailyGoalMl: (currentSettings?['daily_goal_ml'] as int?) ?? 2100,
      lastOpenDate: currentSettings?['last_open_date'] as String?,
      remindersEnabled: reminderSettings.remindersEnabled ? 1 : 0,
      reminderFrequencyHours: reminderSettings.frequencyHours,
      reminderStartTime: reminderSettings.startTime,
      reminderEndTime: reminderSettings.endTime,
      quietStartTime: reminderSettings.quietStart,
      quietEndTime: reminderSettings.quietEnd,
    );
  }

  Future<void> ensureTodayRow({
    required DateTime date,
    required int goalMl,
  }) async {
    await _databaseHelper.ensureDailyIntakeRow(
      intakeDate: dateOnly(date),
      goalMl: goalMl,
    );
  }

  Future<Map<String, dynamic>?> getDailyRow(DateTime date) async {
    return _databaseHelper.getDailyIntakeByDate(dateOnly(date));
  }

  Future<void> saveDailyIntake({
    required DateTime date,
    required int intakeMl,
    required int goalMl,
  }) async {
    await _databaseHelper.upsertDailyIntake(
      intakeDate: dateOnly(date),
      intakeMl: intakeMl,
      goalMl: goalMl,
    );
  }

  Future<void> updateDailyGoalForDate({
    required DateTime date,
    required int goalMl,
  }) async {
    await _databaseHelper.updateDailyGoalForDate(
      intakeDate: dateOnly(date),
      goalMl: goalMl,
    );
  }

  Future<List<HydrationHistoryEntry>> loadHistoryEntries() async {
    final rows = await _databaseHelper.getDailyIntakeRange(
      startDate: '2000-01-01',
      endDate: dateOnly(DateTime.now()),
    );

    return rows.map((row) {
      return HydrationHistoryEntry(
        date: DateTime.parse(row['intake_date'] as String),
        intakeMl: row['intake_ml'] as int,
        goalMl: row['goal_ml'] as int,
      );
    }).toList();
  }

  Future<String?> getLastOpenDate() async {
    final settings = await _databaseHelper.getSettings();
    return settings?['last_open_date'] as String?;
  }

  Future<void> updateLastOpenDate(DateTime date) async {
    await _databaseHelper.updateLastOpenDate(dateOnly(date));
  }
}