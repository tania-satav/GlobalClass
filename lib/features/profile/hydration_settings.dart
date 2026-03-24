import 'package:flutter/material.dart';

class HydrationSettings extends ChangeNotifier {
  static final HydrationSettings instance = HydrationSettings._internal();

  factory HydrationSettings() => instance;

  HydrationSettings._internal();

  double weightKg = 70;
  String activityLevel = 'Medium';
  String unit = 'ml';
  int dailyGoalMl = 2100;

  void updatePersonalisation({
    required double weightKg,
    required String activityLevel,
    required String unit,
    required int dailyGoalMl,
  }) {
    this.weightKg = weightKg;
    this.activityLevel = activityLevel;
    this.unit = unit;
    this.dailyGoalMl = dailyGoalMl;
    notifyListeners();
  }
}
