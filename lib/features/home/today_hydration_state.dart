import 'package:flutter/material.dart';

class TodayHydrationState extends ChangeNotifier {
  static final TodayHydrationState instance = TodayHydrationState._internal();

  factory TodayHydrationState() => instance;

  TodayHydrationState._internal();

  int currentIntakeMl = 650;

  void setCurrentIntake(int value) {
    currentIntakeMl = value < 0 ? 0 : value;
    notifyListeners();
  }

  void reset() {
    currentIntakeMl = 0;
    notifyListeners();
  }
}
