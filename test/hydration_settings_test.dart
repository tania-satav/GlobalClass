import 'package:flutter_test/flutter_test.dart';
import 'package:plant_project/features/profile/hydration_settings.dart';

void main() {
  // HydrationSettings is a singleton, so we reset it manually before each test.
  setUp(() {
    HydrationSettings.instance.loadPersonalisation(
      weightKg: 70,
      activityLevel: 'Medium',
      unit: 'ml',
      dailyGoalMl: 2100,
    );
  });

  group('HydrationSettings – default values', () {
    test('default daily goal is 2100 ml', () {
      expect(HydrationSettings.instance.dailyGoalMl, 2100);
    });

    test('default weight is 70 kg', () {
      expect(HydrationSettings.instance.weightKg, 70.0);
    });

    test('default activity level is Medium', () {
      expect(HydrationSettings.instance.activityLevel, 'Medium');
    });

    test('default unit is ml', () {
      expect(HydrationSettings.instance.unit, 'ml');
    });
  });

  group('HydrationSettings – updatePersonalisation()', () {
    test('updates daily goal correctly', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 3000,
      );
      expect(HydrationSettings.instance.dailyGoalMl, 3000);
    });

    test('updates weight correctly', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 85.5,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 2100,
      );
      expect(HydrationSettings.instance.weightKg, 85.5);
    });

    test('updates activity level correctly', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'High',
        unit: 'ml',
        dailyGoalMl: 2100,
      );
      expect(HydrationSettings.instance.activityLevel, 'High');
    });

    test('updates unit to oz correctly', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'oz',
        dailyGoalMl: 2100,
      );
      expect(HydrationSettings.instance.unit, 'oz');
    });

    test('notifies listeners when values change', () {
      bool notified = false;
      HydrationSettings.instance.addListener(() => notified = true);

      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 1800,
      );

      expect(notified, isTrue);
      HydrationSettings.instance.removeListener(() => notified = true);
    });
  });

  group('HydrationSettings – loadPersonalisation()', () {
    test('loads values silently without notifying listeners', () {
      bool notified = false;
      void listener() => notified = true;
      HydrationSettings.instance.addListener(listener);

      HydrationSettings.instance.loadPersonalisation(
        weightKg: 60,
        activityLevel: 'Low',
        unit: 'oz',
        dailyGoalMl: 1500,
      );

      expect(notified, isFalse);
      expect(HydrationSettings.instance.dailyGoalMl, 1500);
      expect(HydrationSettings.instance.weightKg, 60.0);
      expect(HydrationSettings.instance.activityLevel, 'Low');
      expect(HydrationSettings.instance.unit, 'oz');

      HydrationSettings.instance.removeListener(listener);
    });
  });

  group('HydrationSettings – singleton', () {
    test('factory constructor returns the same instance', () {
      final a = HydrationSettings();
      final b = HydrationSettings();
      expect(identical(a, b), isTrue);
    });

    test('instance and factory constructor point to same object', () {
      expect(identical(HydrationSettings.instance, HydrationSettings()), isTrue);
    });
  });

  group('HydrationSettings – edge cases', () {
    test('goal can be set to 0', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 0,
      );
      expect(HydrationSettings.instance.dailyGoalMl, 0);
    });

    test('goal can be set to a very large value', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 10000,
      );
      expect(HydrationSettings.instance.dailyGoalMl, 10000);
    });

    test('goal can be set to minimum positive value of 1', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 70,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 1,
      );
      expect(HydrationSettings.instance.dailyGoalMl, 1);
    });

    test('weight accepts decimal values', () {
      HydrationSettings.instance.updatePersonalisation(
        weightKg: 72.3,
        activityLevel: 'Medium',
        unit: 'ml',
        dailyGoalMl: 2100,
      );
      expect(HydrationSettings.instance.weightKg, closeTo(72.3, 0.001));
    });
  });
}
