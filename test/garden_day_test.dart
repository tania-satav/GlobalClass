import 'package:flutter_test/flutter_test.dart';
import 'package:HydroMe/features/garden/domain/garden_day.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Helper
  // ---------------------------------------------------------------------------

  GardenDay makeDay({
    DateTime? date,
    int intakeMl = 0,
    int goalMl = 2000,
    FlowerType flowerType = FlowerType.sunflower,
  }) {
    return GardenDay(
      date: date ?? DateTime(2026, 4, 22),
      intakeMl: intakeMl,
      goalMl: goalMl,
      flowerType: flowerType,
    );
  }

  // ---------------------------------------------------------------------------
  // GardenDay – field storage
  // ---------------------------------------------------------------------------

  group('GardenDay – fields', () {
    test('stores date correctly', () {
      final day = makeDay(date: DateTime(2026, 4, 22));
      expect(day.date, DateTime(2026, 4, 22));
    });

    test('stores intakeMl correctly', () {
      final day = makeDay(intakeMl: 1500);
      expect(day.intakeMl, 1500);
    });

    test('stores goalMl correctly', () {
      final day = makeDay(goalMl: 2500);
      expect(day.goalMl, 2500);
    });

    test('stores flowerType correctly', () {
      final day = makeDay(flowerType: FlowerType.blueflower);
      expect(day.flowerType, FlowerType.blueflower);
    });

    test('intakeMl can be 0 (no water logged)', () {
      final day = makeDay(intakeMl: 0);
      expect(day.intakeMl, 0);
    });

    test('intakeMl can equal goalMl (goal reached exactly)', () {
      final day = makeDay(intakeMl: 2000, goalMl: 2000);
      expect(day.intakeMl, day.goalMl);
    });

    test('intakeMl can exceed goalMl (over-goal)', () {
      final day = makeDay(intakeMl: 2500, goalMl: 2000);
      expect(day.intakeMl > day.goalMl, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // GardenDay – progress ratio
  // ---------------------------------------------------------------------------

  group('GardenDay – progress ratio', () {
    test('progress is 0.0 when no intake logged', () {
      final day = makeDay(intakeMl: 0, goalMl: 2000);
      final progress = day.goalMl == 0 ? 0.0 : day.intakeMl / day.goalMl;
      expect(progress, 0.0);
    });

    test('progress is 0.5 at half intake', () {
      final day = makeDay(intakeMl: 1000, goalMl: 2000);
      final progress = day.intakeMl / day.goalMl;
      expect(progress, closeTo(0.5, 0.001));
    });

    test('progress is 1.0 when goal exactly reached', () {
      final day = makeDay(intakeMl: 2000, goalMl: 2000);
      final progress = day.intakeMl / day.goalMl;
      expect(progress, 1.0);
    });

    test('progress exceeds 1.0 when intake is over goal', () {
      final day = makeDay(intakeMl: 2500, goalMl: 2000);
      final progress = day.intakeMl / day.goalMl;
      expect(progress > 1.0, isTrue);
    });

    test('progress clamps to 1.0 when over goal', () {
      final day = makeDay(intakeMl: 3000, goalMl: 2000);
      final progress = (day.intakeMl / day.goalMl).clamp(0.0, 1.0);
      expect(progress, 1.0);
    });

    test('progress guard: goalMl of 0 does not cause division error', () {
      final day = makeDay(intakeMl: 0, goalMl: 0);
      final progress = day.goalMl == 0 ? 0.0 : day.intakeMl / day.goalMl;
      expect(progress, 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // GardenDay – date matching logic
  // Mirrors what GardenController.dayForDate does internally.
  // Tested here directly on a plain list so no database is needed.
  // ---------------------------------------------------------------------------

  group('GardenDay – date matching', () {
    GardenDay? findDay(List<GardenDay> days, DateTime target) {
      try {
        return days.firstWhere(
          (d) =>
              d.date.year == target.year &&
              d.date.month == target.month &&
              d.date.day == target.day,
        );
      } catch (_) {
        return null;
      }
    }

    test('finds the correct day from a list', () {
      final target = DateTime(2026, 4, 22);
      final days = [
        makeDay(date: DateTime(2026, 4, 20)),
        makeDay(date: DateTime(2026, 4, 21)),
        makeDay(date: target, intakeMl: 1500),
      ];
      final result = findDay(days, target);
      expect(result, isNotNull);
      expect(result!.intakeMl, 1500);
    });

    test('ignores time component when matching', () {
      final target = DateTime(2026, 4, 22);
      final days = [makeDay(date: DateTime(2026, 4, 22, 14, 30), intakeMl: 800)];
      final result = findDay(days, target);
      expect(result, isNotNull);
      expect(result!.intakeMl, 800);
    });

    test('returns null when list is empty', () {
      expect(findDay([], DateTime(2026, 4, 22)), isNull);
    });

    test('returns null when date is not in the list', () {
      final days = [
        makeDay(date: DateTime(2026, 4, 20)),
        makeDay(date: DateTime(2026, 4, 21)),
      ];
      expect(findDay(days, DateTime(2026, 4, 22)), isNull);
    });

    test('does not match a day with a different month', () {
      final days = [makeDay(date: DateTime(2026, 3, 22))];
      expect(findDay(days, DateTime(2026, 4, 22)), isNull);
    });

    test('does not match a day with a different year', () {
      final days = [makeDay(date: DateTime(2025, 4, 22))];
      expect(findDay(days, DateTime(2026, 4, 22)), isNull);
    });

    test('correctly retrieves all 7 days of a week individually', () {
      final days = List.generate(
        7,
        (i) => makeDay(date: DateTime(2026, 4, 16 + i), intakeMl: i * 300),
      );
      for (int i = 0; i < 7; i++) {
        final result = findDay(days, DateTime(2026, 4, 16 + i));
        expect(result, isNotNull, reason: 'Day ${i + 1} should be found');
        expect(result!.intakeMl, i * 300);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // FlowerType enum
  // ---------------------------------------------------------------------------

  group('FlowerType – enum values', () {
    test('has exactly four flower types', () {
      expect(FlowerType.values.length, 4);
    });

    test('sunflower variant exists', () {
      expect(FlowerType.values, contains(FlowerType.sunflower));
    });

    test('blueflower variant exists', () {
      expect(FlowerType.values, contains(FlowerType.blueflower));
    });

    test('redflower variant exists', () {
      expect(FlowerType.values, contains(FlowerType.redflower));
    });

    test('purpleflower variant exists', () {
      expect(FlowerType.values, contains(FlowerType.purpleflower));
    });

    test('all four flower types are distinct', () {
      expect(FlowerType.values.toSet().length, 4);
    });
  });

  // ---------------------------------------------------------------------------
  // FlowerType – deterministic assignment by date
  // Mirrors controller logic: (year + month + day) % 4
  // ---------------------------------------------------------------------------

  group('FlowerType – deterministic assignment by date', () {
    FlowerType assignFlower(DateTime date) {
      final r = (date.year + date.month + date.day) % 4;
      switch (r) {
        case 0:  return FlowerType.sunflower;
        case 1:  return FlowerType.blueflower;
        case 2:  return FlowerType.redflower;
        default: return FlowerType.purpleflower;
      }
    }

    test('same date always produces the same flower type', () {
      final date = DateTime(2026, 4, 22);
      expect(assignFlower(date), assignFlower(date));
    });

    test('consecutive dates produce different flower types', () {
      expect(
        assignFlower(DateTime(2026, 4, 22)),
        isNot(equals(assignFlower(DateTime(2026, 4, 23)))),
      );
    });

    test('seed % 4 == 0 produces sunflower', () {
      // 2024 + 4 + 4 = 2032, % 4 = 0
      expect(assignFlower(DateTime(2024, 4, 4)), FlowerType.sunflower);
    });

    test('seed % 4 == 1 produces blueflower', () {
      // 2024 + 4 + 5 = 2033, % 4 = 1
      expect(assignFlower(DateTime(2024, 4, 5)), FlowerType.blueflower);
    });

    test('seed % 4 == 2 produces redflower', () {
      // 2024 + 4 + 6 = 2034, % 4 = 2
      expect(assignFlower(DateTime(2024, 4, 6)), FlowerType.redflower);
    });

    test('seed % 4 == 3 produces purpleflower', () {
      // 2024 + 4 + 7 = 2035, % 4 = 3
      expect(assignFlower(DateTime(2024, 4, 7)), FlowerType.purpleflower);
    });

    test('all flower types across a 7-day week are valid enum values', () {
      final week = List.generate(7, (i) => assignFlower(DateTime(2026, 4, 16 + i)));
      for (final flower in week) {
        expect(FlowerType.values, contains(flower));
      }
    });
  });
}
