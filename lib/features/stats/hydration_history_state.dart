import 'package:flutter/foundation.dart';

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

  final List<HydrationHistoryEntry> _entries = [];

  List<HydrationHistoryEntry> get entries {
    final copiedEntries = List<HydrationHistoryEntry>.from(_entries);
    copiedEntries.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(copiedEntries);
  }

  bool addOrUpdateEntry({
    required DateTime date,
    required int intakeMl,
    required int goalMl,
  }) {
    final normalizedDate = _normalizeDate(date);

    final index = _entries.indexWhere(
      (entry) => _isSameDay(entry.date, normalizedDate),
    );

    final newEntry = HydrationHistoryEntry(
      date: normalizedDate,
      intakeMl: intakeMl,
      goalMl: goalMl,
    );

    if (index >= 0) {
      final existingEntry = _entries[index];

      final isUnchanged =
          existingEntry.intakeMl == intakeMl &&
          existingEntry.goalMl == goalMl &&
          _isSameDay(existingEntry.date, normalizedDate);

      if (isUnchanged) {
        return false;
      }

      _entries[index] = newEntry;
      notifyListeners();
      return true;
    } else {
      _entries.add(newEntry);
      notifyListeners();
      return true;
    }
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

  void clearAll() {
    _entries.clear();
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
