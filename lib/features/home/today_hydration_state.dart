import 'package:flutter/material.dart';
import '../../repositories/hydration_repository.dart';

class TodayHydrationState extends ChangeNotifier {
  static final TodayHydrationState instance = TodayHydrationState._internal();

  factory TodayHydrationState() => instance;

  TodayHydrationState._internal();

  final HydrationRepository _repository = HydrationRepository.instance;

  int currentIntakeMl = 0;
  int currentFlowerVariant = 0;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<int> _flowerPool = [0, 1, 2, 3];

  // -------------------------------
  // LOAD TODAY DATA
  // -------------------------------
  Future<void> loadToday({required int goalMl}) async {
    final today = DateTime.now();
    final todayKey = _repository.dateOnly(today);
    final lastOpenDate = await _repository.getLastOpenDate();

    await _repository.ensureTodayRow(
      date: today,
      goalMl: goalMl,
    );

    if (lastOpenDate == null || lastOpenDate != todayKey) {
      await _repository.updateLastOpenDate(today);
    }

    final row = await _repository.getDailyRow(today);

    currentIntakeMl = (row?['intake_ml'] as int?) ?? 0;

    _isLoaded = true;
    notifyListeners();
  }

  // -------------------------------
  // GET RANGE DATA (USED BY GARDEN)
  // -------------------------------
  Future<List<Map<String, dynamic>>> getRangeData(
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.getDailyRange(start, end);
  }

  // -------------------------------
  // UPDATE INTAKE
  // -------------------------------
  Future<void> setCurrentIntake({
    required int value,
    required int goalMl,
  }) async {
    final safeValue = value < 0 ? 0 : value;
    final today = DateTime.now();

    final previousMl = currentIntakeMl;
    currentIntakeMl = safeValue;

    await _repository.saveDailyIntake(
      date: today,
      intakeMl: currentIntakeMl,
      goalMl: goalMl,
    );

    await _repository.updateLastOpenDate(today);

    // unlock flower only once per goal reach
    if (previousMl < goalMl && currentIntakeMl >= goalMl) {
      _generateNextFlowerVariant();
    }

    notifyListeners();
  }

  // -------------------------------
  // WATER ACTIONS
  // -------------------------------
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

  // -------------------------------
  // FLOWER VARIATION SYSTEM
  // -------------------------------
  void _generateNextFlowerVariant() {
    if (_flowerPool.isEmpty) {
      _flowerPool = [0, 1, 2, 3]..shuffle();
    }

    currentFlowerVariant = _flowerPool.removeLast();
  }
}