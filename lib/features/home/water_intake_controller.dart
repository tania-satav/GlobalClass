import 'package:flutter/material.dart';

class WaterIntakeController extends ChangeNotifier {
  int goalMl;
  int currentMl;

  WaterIntakeController({this.goalMl = 1500, this.currentMl = 650});

  void addWater(int amount) {
    currentMl += amount;

    if (currentMl > goalMl) {
      currentMl = goalMl;
    }

    notifyListeners();
  }

  void removeWater(int amount) {
    currentMl -= amount;

    if (currentMl < 0) {
      currentMl = 0;
    }

    notifyListeners();
  }

  void resetWater() {
    currentMl = 0;
    notifyListeners();
  }

  void updateGoal(int newGoalMl) {
    goalMl = newGoalMl;

    if (currentMl > goalMl) {
      currentMl = goalMl;
    }

    notifyListeners();
  }
}
