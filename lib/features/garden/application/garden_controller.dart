import 'package:flutter/material.dart';
import '../../../repositories/hydration_repository.dart';
import '../domain/garden_day.dart';

class GardenController extends ChangeNotifier {
  final HydrationRepository _repo =
      HydrationRepository.instance;

  List<GardenDay> days = [];

  bool isLoading = false;

  GardenController() {
    loadWeek();
  }

  // -----------------------------
  // STABLE RANDOM FLOWER
  // (based on date)
  // -----------------------------

  FlowerType _assignFlowerType(
      DateTime date) {
    final seed =
        date.year +
        date.month +
        date.day;

    final r = seed % 4;

    switch (r) {
      case 0:
        return FlowerType.sunflower;
      case 1:
        return FlowerType.blueflower;
      case 2:
        return FlowerType.redflower;
      default:
        return FlowerType.purpleflower;
    }
  }

  // -----------------------------
  // LOAD WEEK
  // -----------------------------

  Future<void> loadWeek() async {
    isLoading = true;
    notifyListeners();

    final end = DateTime.now();
    final start =
        end.subtract(const Duration(days: 6));

    final data =
        await _repo.getDailyRange(start, end);

    days = data.map((row) {
      final date =
          DateTime.parse(row['intake_date']);

      final intake =
          row['intake_ml'] ?? 0;

      final goal =
          row['goal_ml'] ?? 2000;

      return GardenDay(
        date: date,
        intakeMl: intake,
        goalMl: goal,
        flowerType:
            _assignFlowerType(date),
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  GardenDay? dayForDate(
      DateTime day) {
    try {
      return days.firstWhere(
        (d) =>
            d.date.year ==
                day.year &&
            d.date.month ==
                day.month &&
            d.date.day == day.day,
      );
    } catch (_) {
      return null;
    }
  }
}