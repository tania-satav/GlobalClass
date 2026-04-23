import 'package:intl/intl.dart';

class WeekUtils {
  /// Returns Monday of the current week
  static DateTime getStartOfWeek() {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday; // Monday = 1

    return today.subtract(Duration(days: weekday - 1));
  }

  /// Builds a list from Monday → Sunday
  static List<DateTime> buildWeekDays() {
    final startOfWeek = getStartOfWeek();

    return List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
  }

  /// Checks if a given day is in the future
  static bool isFutureDay(DateTime day) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final targetDate = DateTime(day.year, day.month, day.day);

    return targetDate.isAfter(todayDate);
  }

  /// Returns short weekday label (Mon, Tue, etc.)
  static String getDayLabel(DateTime day) {
    return DateFormat.E().format(day);
  }
}