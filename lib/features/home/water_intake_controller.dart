import 'package:flutter/material.dart';

class WaterIntakeController extends ChangeNotifier {
  int goalMl;
  int currentMl;

  WaterIntakeController({this.goalMl = 1500, this.currentMl = 0});

  void loadState({
    required int goalMl,
    required int currentMl,
  }) {
    this.goalMl = goalMl;
    this.currentMl = currentMl < 0 ? 0 : currentMl;
    notifyListeners();
  }

  void addWater(int amount) {
    currentMl += amount;
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
    notifyListeners();
  }
}