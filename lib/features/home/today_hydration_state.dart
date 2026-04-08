import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

class TodayHydrationState extends ChangeNotifier {
  static final TodayHydrationState instance = TodayHydrationState._internal();

  factory TodayHydrationState() => instance;

  TodayHydrationState._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int currentIntakeMl = 0;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> loadToday({required int goalMl}) async {
    final today = _dateOnly(DateTime.now());

    await _databaseHelper.ensureDailyIntakeRow(
      intakeDate: today,
      goalMl: goalMl,
    );

    final row = await _databaseHelper.getDailyIntakeByDate(today);

    currentIntakeMl = (row?['intake_ml'] as int?) ?? 0;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setCurrentIntake({
    required int value,
    required int goalMl,
  }) async {
    final safeValue = value < 0 ? 0 : value;
    final today = _dateOnly(DateTime.now());

    currentIntakeMl = safeValue;

    await _databaseHelper.upsertDailyIntake(
      intakeDate: today,
      intakeMl: currentIntakeMl,
      goalMl: goalMl,
    );

    notifyListeners();
  }

  Future<void> addWater({
    required int amount,
    required int goalMl,
  }) async {
    await setCurrentIntake(
      value: currentIntakeMl + amount,
      goalMl: goalMl,
    );
  }

  Future<void> removeWater({
    required int amount,
    required int goalMl,
  }) async {
    await setCurrentIntake(
      value: currentIntakeMl - amount,
      goalMl: goalMl,
    );
  }

  Future<void> reset({required int goalMl}) async {
    await setCurrentIntake(value: 0, goalMl: goalMl);
  }
}