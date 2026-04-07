import 'package:shared_preferences/shared_preferences.dart';
import 'hydration_settings.dart';

class HydrationSettingsStorage {
  static const String _dailyGoalKey = 'daily_goal_ml';
  static const int _defaultDailyGoalMl = 2000;

  static Future<int> loadDailyGoalMl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyGoalKey) ?? _defaultDailyGoalMl;
  }

  static Future<void> saveDailyGoalMl(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, value);
  }

  static Future<HydrationSettings> load() async {
    final goal = await loadDailyGoalMl();
    final settings = HydrationSettings.instance;
    settings.dailyGoalMl = goal;
    return settings;
  }

  static Future<void> save(HydrationSettings settings) async {
    await saveDailyGoalMl(settings.dailyGoalMl);
  }
}
