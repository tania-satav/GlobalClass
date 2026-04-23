import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../home/widgets/home_bottom_nav.dart';
import '../profile/profile_screen.dart';
import '../stats/hydration_history_state.dart';
import '../stats/stats_screen.dart';
import '../garden/presentation/garden_screen.dart';

class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});

  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  final HydrationHistoryState _historyState = HydrationHistoryState.instance;

  @override
  void initState() {
    super.initState();
    _initializeHistory();
  }

  Future<void> _initializeHistory() async {
    await _historyState.loadHistory();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _didHitGoalOnDate(DateTime date) {
    final entry = _historyState.entryForDate(date);
    if (entry == null) return false;
    return entry.intakeMl >= entry.goalMl;
  }

  int _calculateCurrentStreak() {
    final today = _normalizeDate(DateTime.now());
    int streak = 0;

    if (_didHitGoalOnDate(today)) {
      DateTime cursor = today;

      while (_didHitGoalOnDate(cursor)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      }

      return streak;
    }

    final yesterday = today.subtract(const Duration(days: 1));
    DateTime cursor = yesterday;

    while (_didHitGoalOnDate(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  List<_WeekDayStatus> _buildCurrentWeekStatuses() {
    final today = _normalizeDate(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));

    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return List.generate(7, (index) {
      final date = monday.add(Duration(days: index));

      return _WeekDayStatus(
        label: labels[index],
        isToday: _isSameDay(date, today),
        goalHit: _didHitGoalOnDate(date),
      );
    });
  }

  // ✅ FIXED NAVIGATION ORDER
  void _handleNavTap(int index) {
    if (index == 3) return; // already on streaks

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GardenScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StatsScreen()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _historyState,
      builder: (context, _) {
        if (!_historyState.isLoaded) {
          return const Scaffold(
            backgroundColor: Color(0xFFD6F1F7),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final streak = _calculateCurrentStreak();
        final weekStatuses = _buildCurrentWeekStatuses();

        return Scaffold(
          backgroundColor: const Color(0xFFD6F1F7),

          // ✅ FIXED INDEX
          bottomNavigationBar: HomeBottomNav(
            currentIndex: 3,
            onTap: _handleNavTap,
          ),

          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFD6F1F7),
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper3.png'),
                fit: BoxFit.cover,
              ),
            ),

            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 🌿 HEADER BANNER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A7DAC),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'KeepMe Hydrated',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),

                          Image.asset(
                            'assets/icons/watericonwhite.png',
                            width: 100,
                            height: 100,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            '$streak DAY STREAK',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF6ED3E8),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            streak > 0
                                ? 'You have hit your hydration goal for $streak day${streak == 1 ? '' : 's'} in a row.'
                                : 'Hit your hydration goal today to start a new streak.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5E5E5E),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: weekStatuses.map((day) {
                              return _DayDrop(
                                label: day.label,
                                selected: day.isToday,
                                completed: day.goalHit,
                              );
                            }).toList(),
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A7DAC),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                streak > 0
                                    ? 'KEEP YOUR STREAK GOING\nLOG WATER TODAY'
                                    : 'LOG WATER TO START\nYOUR STREAK',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayDrop extends StatelessWidget {
  final String label;
  final bool selected;
  final bool completed;

  const _DayDrop({
    required this.label,
    this.selected = false,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (completed) {
      color = const Color(0xFF0F86C8);
    } else if (selected) {
      color = const Color(0xFF7DD9FF);
    } else {
      color = const Color(0xFF8BE7D7);
    }

    return Column(
      children: [
        Icon(Icons.water_drop, size: 34, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5E5E5E),
          ),
        ),
      ],
    );
  }
}

class _WeekDayStatus {
  final String label;
  final bool isToday;
  final bool goalHit;

  const _WeekDayStatus({
    required this.label,
    required this.isToday,
    required this.goalHit,
  });
}