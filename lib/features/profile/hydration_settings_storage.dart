import '../../database/database_helper.dart';
import 'hydration_settings.dart';

class HydrationSettingsStorage {
  static const int _defaultDailyGoalMl = 2100;
  static final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  static Future<int> loadDailyGoalMl() async {
    final settings = await _databaseHelper.getSettings();
    return (settings?['daily_goal_ml'] as int?) ?? _defaultDailyGoalMl;
  }

  static Future<void> saveDailyGoalMl(int value) async {
    final currentSettings = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: (currentSettings?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel:
          (currentSettings?['activity_level'] as String?) ?? 'Medium',
      unit: (currentSettings?['unit'] as String?) ?? 'ml',
      dailyGoalMl: value,
      lastOpenDate: currentSettings?['last_open_date'] as String?,
    );
  }

  static Future<HydrationSettings> load() async {
    final settingsRow = await _databaseHelper.getSettings();
    final settings = HydrationSettings.instance;

    settings.loadPersonalisation(
      weightKg: (settingsRow?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel:
          (settingsRow?['activity_level'] as String?) ?? 'Medium',
      unit: (settingsRow?['unit'] as String?) ?? 'ml',
      dailyGoalMl: (settingsRow?['daily_goal_ml'] as int?) ?? _defaultDailyGoalMl,
    );

    return settings;
  }

  static Future<void> save(HydrationSettings settings) async {
    final currentSettings = await _databaseHelper.getSettings();

    await _databaseHelper.upsertSettings(
      weightKg: settings.weightKg,
      activityLevel: settings.activityLevel,
      unit: settings.unit,
      dailyGoalMl: settings.dailyGoalMl,
      lastOpenDate: currentSettings?['last_open_date'] as String?,
    );
  }
}