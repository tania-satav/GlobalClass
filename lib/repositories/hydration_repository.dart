import '../database/database_helper.dart';
import '../features/profile/hydration_settings.dart';
import '../features/profile/reminder_settings.dart';
import '../features/stats/hydration_history_state.dart';

class HydrationRepository {
  HydrationRepository._internal();

  static final HydrationRepository instance =
      HydrationRepository._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // -------------------------------
  // DATE HELPERS
  // -------------------------------
  String dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // -------------------------------
  // SETTINGS
  // -------------------------------
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
      activityLevel: (settingsRow?['activity_level'] as String?) ?? 'Medium',
      unit: (settingsRow?['unit'] as String?) ?? 'ml',
      dailyGoalMl: (settingsRow?['daily_goal_ml'] as int?) ?? 2100,
    );

    return settings;
  }

  Future<void> saveHydrationSettings(HydrationSettings settings) async {
    final current = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: settings.weightKg,
      activityLevel: settings.activityLevel,
      unit: settings.unit,
      dailyGoalMl: settings.dailyGoalMl,
      lastOpenDate: current?['last_open_date'] as String?,
      remindersEnabled: (current?['reminders_enabled'] as int?) ?? 1,
      reminderFrequencyHours:
          (current?['reminder_frequency_hours'] as int?) ?? 2,
      reminderStartTime:
          (current?['reminder_start_time'] as String?) ?? '09:00',
      reminderEndTime:
          (current?['reminder_end_time'] as String?) ?? '22:00',
      quietStartTime:
          (current?['quiet_start_time'] as String?) ?? '23:00',
      quietEndTime:
          (current?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  Future<void> saveDailyGoalMl(int value) async {
    final current = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: (current?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel: (current?['activity_level'] as String?) ?? 'Medium',
      unit: (current?['unit'] as String?) ?? 'ml',
      dailyGoalMl: value,
      lastOpenDate: current?['last_open_date'] as String?,
      remindersEnabled: (current?['reminders_enabled'] as int?) ?? 1,
      reminderFrequencyHours:
          (current?['reminder_frequency_hours'] as int?) ?? 2,
      reminderStartTime:
          (current?['reminder_start_time'] as String?) ?? '09:00',
      reminderEndTime:
          (current?['reminder_end_time'] as String?) ?? '22:00',
      quietStartTime:
          (current?['quiet_start_time'] as String?) ?? '23:00',
      quietEndTime:
          (current?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  // -------------------------------
  // REMINDERS
  // -------------------------------
  Future<ReminderSettings> loadReminderSettings() async {
    final row = await _databaseHelper.getSettings();

    return ReminderSettings(
      remindersEnabled: ((row?['reminders_enabled'] as int?) ?? 1) == 1,
      frequencyHours: (row?['reminder_frequency_hours'] as int?) ?? 2,
      startTime: (row?['reminder_start_time'] as String?) ?? '09:00',
      endTime: (row?['reminder_end_time'] as String?) ?? '22:00',
      quietStart: (row?['quiet_start_time'] as String?) ?? '23:00',
      quietEnd: (row?['quiet_end_time'] as String?) ?? '07:00',
    );
  }

  Future<void> saveReminderSettings(ReminderSettings settings) async {
    final current = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: (current?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel: (current?['activity_level'] as String?) ?? 'Medium',
      unit: (current?['unit'] as String?) ?? 'ml',
      dailyGoalMl: (current?['daily_goal_ml'] as int?) ?? 2100,
      lastOpenDate: current?['last_open_date'] as String?,
      remindersEnabled: settings.remindersEnabled ? 1 : 0,
      reminderFrequencyHours: settings.frequencyHours,
      reminderStartTime: settings.startTime,
      reminderEndTime: settings.endTime,
      quietStartTime: settings.quietStart,
      quietEndTime: settings.quietEnd,
    );
  }

  // -------------------------------
  // DAILY DATA
  // -------------------------------
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

  // -------------------------------
  // 🔥 GARDEN FEATURE (FIXED)
  // -------------------------------
  Future<List<Map<String, dynamic>>> getDailyRange(
    DateTime start,
    DateTime end,
  ) async {
    return _databaseHelper.getDailyIntakeRange(
      startDate: dateOnly(start),
      endDate: dateOnly(end),
    );
  }

  // -------------------------------
  // HISTORY
  // -------------------------------
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

  // -------------------------------
  // LAST OPEN DATE
  // -------------------------------
  Future<String?> getLastOpenDate() async {
    final settings = await _databaseHelper.getSettings();
    return settings?['last_open_date'] as String?;
  }

  Future<void> updateLastOpenDate(DateTime date) async {
    await _databaseHelper.updateLastOpenDate(dateOnly(date));
  }
}