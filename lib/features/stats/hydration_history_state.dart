import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'intakeMl': intakeMl,
      'goalMl': goalMl,
    };
  }

  factory HydrationHistoryEntry.fromJson(Map<String, dynamic> json) {
    return HydrationHistoryEntry(
      date: DateTime.parse(json['date'] as String),
      intakeMl: json['intakeMl'] as int,
      goalMl: json['goalMl'] as int,
    );
  }
}

class HydrationHistoryState extends ChangeNotifier {
  static final HydrationHistoryState instance =
      HydrationHistoryState._internal();

  static const String _storageKey = 'hydration_history_entries';

  HydrationHistoryState._internal();

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

    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_storageKey);

    if (rawJson != null && rawJson.isNotEmpty) {
      final decoded = jsonDecode(rawJson) as List<dynamic>;

      _entries
        ..clear()
        ..addAll(
          decoded.map(
            (item) => HydrationHistoryEntry.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
    }

    _isLoaded = true;
    notifyListeners();
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
      _saveHistory();
      notifyListeners();
      return true;
    } else {
      _entries.add(newEntry);
      _saveHistory();
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
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _entries.map((entry) => entry.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
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
