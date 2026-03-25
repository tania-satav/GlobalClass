import 'package:shared_preferences/shared_preferences.dart';
import 'hydration_settings.dart';

class HydrationSettingsStorage {
  static const String _weightKey = 'hydration_weight_kg';
  static const String _activityLevelKey = 'hydration_activity_level';
  static const String _unitKey = 'hydration_unit';
  static const String _dailyGoalKey = 'hydration_daily_goal_ml';

  static Future<void> save(HydrationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_weightKey, settings.weightKg);
    await prefs.setString(_activityLevelKey, settings.activityLevel);
    await prefs.setString(_unitKey, settings.unit);
    await prefs.setInt(_dailyGoalKey, settings.dailyGoalMl);
  }

  static Future<void> loadInto(HydrationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    settings.loadPersonalisation(
      weightKg: prefs.getDouble(_weightKey) ?? settings.weightKg,
      activityLevel:
          prefs.getString(_activityLevelKey) ?? settings.activityLevel,
      unit: prefs.getString(_unitKey) ?? settings.unit,
      dailyGoalMl: prefs.getInt(_dailyGoalKey) ?? settings.dailyGoalMl,
    );
  }
}
