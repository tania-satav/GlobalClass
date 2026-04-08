import 'package:flutter/foundation.dart';
import '../../database/database_helper.dart';

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

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  final List<HydrationHistoryEntry> _entries = [];
  bool _isLoaded = false;

  List<HydrationHistoryEntry> get entries {
    final copiedEntries = List<HydrationHistoryEntry>.from(_entries);
    copiedEntries.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(copiedEntries);
  }

  bool get isLoaded => _isLoaded;

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> loadHistory() async {
    if (_isLoaded) return;
    await refreshHistory();
  }

  Future<void> refreshHistory() async {
    final rows = await _databaseHelper.getDailyIntakeRange(
      startDate: '2000-01-01',
      endDate: _dateOnly(DateTime.now()),
    );

    _entries
      ..clear()
      ..addAll(
        rows.map((row) {
          return HydrationHistoryEntry(
            date: DateTime.parse(row['intake_date'] as String),
            intakeMl: row['intake_ml'] as int,
            goalMl: row['goal_ml'] as int,
          );
        }),
      );

    _isLoaded = true;
    notifyListeners();
  }

  Future<bool> addOrUpdateEntry({
    required DateTime date,
    required int intakeMl,
    required int goalMl,
  }) async {
    final normalizedDate = _normalizeDate(date);
    final dateKey = _dateOnly(normalizedDate);

    final existing = entryForDate(normalizedDate);

    if (existing != null &&
        existing.intakeMl == intakeMl &&
        existing.goalMl == goalMl) {
      return false;
    }

    await _databaseHelper.upsertDailyIntake(
      intakeDate: dateKey,
      intakeMl: intakeMl,
      goalMl: goalMl,
    );

    await refreshHistory();
    return true;
  }

  HydrationHistoryEntry? entryForDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    try {
      return _entries.firstWhere(
        (entry) => _isSameDay(entry.date, normalizedDate),
      );
    } catch (_) {
      return null;
    }
  }

  List<HydrationHistoryEntry> entriesForLast7Days() {
    final today = _normalizeDate(DateTime.now());
    final cutoff = today.subtract(const Duration(days: 6));

    final filtered = _entries.where((entry) {
      final entryDate = _normalizeDate(entry.date);
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
    final today = _normalizeDate(DateTime.now());
    final cutoff = DateTime(today.year - 1, today.month, today.day);

    final filtered = _entries.where((entry) {
      final entryDate = _normalizeDate(entry.date);
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

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}