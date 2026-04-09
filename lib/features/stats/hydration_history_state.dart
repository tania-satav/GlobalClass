import 'package:flutter/foundation.dart';
import '../../repositories/hydration_repository.dart';

class HydrationHistoryEntry {
  final DateTime date;
  final int intakeMl;
  final int goalMl;

  const HydrationHistoryEntry({
    required this.date,
    required this.intakeMl,
    required this.goalMl,
  });

  HydrationHistoryEntry copyWith({DateTime? date, int? intakeMl, int? goalMl}) {
    return HydrationHistoryEntry(
      date: date ?? this.date,
      intakeMl: intakeMl ?? this.intakeMl,
      goalMl: goalMl ?? this.goalMl,
    );
  }
}

class HydrationHistoryState extends ChangeNotifier {
  static final HydrationHistoryState instance =
      HydrationHistoryState._internal();

  HydrationHistoryState._internal();

  final HydrationRepository _repository = HydrationRepository.instance;

  final List<HydrationHistoryEntry> _entries = [];
  bool _isLoaded = false;

  List<HydrationHistoryEntry> get entries {
    final copiedEntries = List<HydrationHistoryEntry>.from(_entries);
    copiedEntries.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(copiedEntries);
  }

  bool get isLoaded => _isLoaded;

  Future<void> loadHistory() async {
    if (_isLoaded) return;
    await refreshHistory();
  }

  Future<void> refreshHistory() async {
    final loadedEntries = await _repository.loadHistoryEntries();

    _entries
      ..clear()
      ..addAll(loadedEntries);

    _isLoaded = true;
    notifyListeners();
  }

  Future<bool> addOrUpdateEntry({
    required DateTime date,
    required int intakeMl,
    required int goalMl,
  }) async {
    final normalizedDate = _repository.normalizeDate(date);
    final existing = entryForDate(normalizedDate);

    if (existing != null &&
        existing.intakeMl == intakeMl &&
        existing.goalMl == goalMl) {
      return false;
    }

    await _repository.saveDailyIntake(
      date: normalizedDate,
      intakeMl: intakeMl,
      goalMl: goalMl,
    );

    await refreshHistory();
    return true;
  }

  HydrationHistoryEntry? entryForDate(DateTime date) {
    final normalizedDate = _repository.normalizeDate(date);

    try {
      return _entries.firstWhere(
        (entry) => _isSameDay(entry.date, normalizedDate),
      );
    } catch (_) {
      return null;
    }
  }

  List<HydrationHistoryEntry> entriesForLast7Days() {
    final today = _repository.normalizeDate(DateTime.now());
    final cutoff = today.subtract(const Duration(days: 6));

    final filtered = _entries.where((entry) {
      final entryDate = _repository.normalizeDate(entry.date);
      return !entryDate.isBefore(cutoff) && !entryDate.isAfter(today);
    }).toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  List<HydrationHistoryEntry> entriesForThisMonth() {
    final now = DateTime.now();

    final filtered = _entries.where((entry) {
      return entry.date.year == now.year && entry.date.month == now.month;
    }).toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  List<HydrationHistoryEntry> entriesForPast12Months() {
    final today = _repository.normalizeDate(DateTime.now());
    final cutoff = DateTime(today.year - 1, today.month, today.day);

    final filtered = _entries.where((entry) {
      final entryDate = _repository.normalizeDate(entry.date);
      return !entryDate.isBefore(cutoff) && !entryDate.isAfter(today);
    }).toList();

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  Future<void> clearAll() async {
    _entries.clear();
    _isLoaded = true;
    notifyListeners();
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}