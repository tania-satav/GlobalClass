import '../../repositories/hydration_repository.dart';
import 'reminder_settings.dart';

class ReminderSettingsStorage {
  static final HydrationRepository _repository = HydrationRepository.instance;

  static Future<ReminderSettings> load() async {
    return _repository.loadReminderSettings();
  }

  static Future<void> save(ReminderSettings reminderSettings) async {
    await _repository.saveReminderSettings(reminderSettings);
  }
}