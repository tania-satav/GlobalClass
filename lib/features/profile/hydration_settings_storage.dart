import '../../repositories/hydration_repository.dart';
import 'hydration_settings.dart';

class HydrationSettingsStorage {
  static final HydrationRepository _repository = HydrationRepository.instance;

  static Future<int> loadDailyGoalMl() async {
    return _repository.loadDailyGoalMl();
  }

  static Future<void> saveDailyGoalMl(int value) async {
    await _repository.saveDailyGoalMl(value);
  }

  static Future<HydrationSettings> load() async {
    return _repository.loadHydrationSettings();
  }

  static Future<void> save(HydrationSettings settings) async {
    await _repository.saveHydrationSettings(settings);
  }
}