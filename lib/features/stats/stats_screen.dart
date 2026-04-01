import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../home/today_hydration_state.dart';
import '../home/widgets/home_bottom_nav.dart';
import '../profile/hydration_settings.dart';
import 'hydration_history_state.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedRange = 'Last 7 Days';

  final List<String> _ranges = const [
    'Last 7 Days',
    'This Month',
    'Past 12 Months',
  ];

  final HydrationSettings _settings = HydrationSettings.instance;
  final TodayHydrationState _todayHydrationState = TodayHydrationState.instance;
  final HydrationHistoryState _historyState = HydrationHistoryState.instance;

  int get _todayGoalMl => _settings.dailyGoalMl;
  int get _todayIntakeMl => _todayHydrationState.currentIntakeMl;

  int get _remainingOrOverMl => _todayIntakeMl - _todayGoalMl;

  List<HydrationHistoryEntry> get _filteredHistoryEntries {
    switch (_selectedRange) {
      case 'Last 7 Days':
        return _historyState.entriesForLast7Days();
      case 'This Month':
        return _historyState.entriesForThisMonth();
      case 'Past 12 Months':
        return _historyState.entriesForPast12Months();
      default:
        return _historyState.entriesForLast7Days();
    }
  }

  int get _daysLogged => _filteredHistoryEntries.length;

  int get _dailyGoalHits => _filteredHistoryEntries
      .where((entry) => entry.intakeMl >= entry.goalMl)
      .length;

  int get _totalIntakeMl =>
      _filteredHistoryEntries.fold(0, (sum, entry) => sum + entry.intakeMl);

  int get _averageIntakeMl {
    if (_filteredHistoryEntries.isEmpty) return 0;
    return (_totalIntakeMl / _filteredHistoryEntries.length).round();
  }

  int get _goalHitRatePercent {
    if (_filteredHistoryEntries.isEmpty) return 0;
    return ((_dailyGoalHits / _filteredHistoryEntries.length) * 100)
        .round()
        .clamp(0, 100);
  }

  String get _remainingOrOverText {
    if (_remainingOrOverMl == 0) {
      return 'Goal reached';
    }
    if (_remainingOrOverMl > 0) {
      return '+${_remainingOrOverMl} ml';
    }
    return '${-_remainingOrOverMl} ml left';
  }

  String get _remainingOrOverSubtitle {
    if (_remainingOrOverMl == 0) {
      return 'You hit your goal exactly today';
    }
    if (_remainingOrOverMl > 0) {
      return 'You are over today’s goal';
    }
    return 'Still remaining to hit today’s goal';
  }

  int get _completionPercent {
    if (_todayGoalMl <= 0) return 0;
    return ((_todayIntakeMl / _todayGoalMl) * 100).round().clamp(0, 999);
  }

  @override
  void initState() {
    super.initState();
    _initializeHistory();
    _settings.addListener(_syncTodayIntoHistory);
    _todayHydrationState.addListener(_syncTodayIntoHistory);
  }

  @override
  void dispose() {
    _settings.removeListener(_syncTodayIntoHistory);
    _todayHydrationState.removeListener(_syncTodayIntoHistory);
    super.dispose();
  }

  Future<void> _initializeHistory() async {
    await _historyState.loadHistory();
    _syncTodayIntoHistory();
  }

  void _syncTodayIntoHistory() {
    if (!_historyState.isLoaded) return;

    _historyState.addOrUpdateEntry(
      date: DateTime.now(),
      intakeMl: _todayIntakeMl,
      goalMl: _todayGoalMl,
    );
  }

  String _formatEntryLabel(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday ${date.day} $month';
  }

  String get _historySectionTitle {
    switch (_selectedRange) {
      case 'Last 7 Days':
        return 'Hydration History (Last 7 Days)';
      case 'This Month':
        return 'Hydration History (This Month)';
      case 'Past 12 Months':
        return 'Hydration History (Past 12 Months)';
      default:
        return 'Hydration History';
    }
  }

  String get _rangeSummaryTitle {
    switch (_selectedRange) {
      case 'Last 7 Days':
        return 'Range Summary (Last 7 Days)';
      case 'This Month':
        return 'Range Summary (This Month)';
      case 'Past 12 Months':
        return 'Range Summary (Past 12 Months)';
      default:
        return 'Range Summary';
    }
  }

  String get _dailyGoalHitsSubtitle {
    switch (_selectedRange) {
      case 'Last 7 Days':
        return 'Days where your goal was reached in the last 7 days';
      case 'This Month':
        return 'Days where your goal was reached this month';
      case 'Past 12 Months':
        return 'Days where your goal was reached in the past 12 months';
      default:
        return 'Days where your goal was reached';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _settings,
        _todayHydrationState,
        _historyState,
      ]),
      builder: (context, _) {
        if (!_historyState.isLoaded) {
          return const Scaffold(
            backgroundColor: Color(0xFFAEDFEA),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final filteredEntries = _filteredHistoryEntries;

        return Scaffold(
          backgroundColor: const Color(0xFFAEDFEA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFAEDFEA),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'STATS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Track your hydration progress over time.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'Time Range',
                    child: SegmentedButton<String>(
                      segments: _ranges.map((range) {
                        return ButtonSegment<String>(
                          value: range,
                          label: Text(range),
                        );
                      }).toList(),
                      selected: {_selectedRange},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _selectedRange = selection.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      _SummaryCard(
                        title: 'Today’s Goal',
                        value: '$_todayGoalMl ml',
                        subtitle: 'Target for today',
                      ),
                      _SummaryCard(
                        title: 'Today’s Intake',
                        value: '$_todayIntakeMl ml',
                        subtitle: 'What you have logged today',
                      ),
                      _SummaryCard(
                        title: 'Remaining / Over',
                        value: _remainingOrOverText,
                        subtitle: _remainingOrOverSubtitle,
                      ),
                      _SummaryCard(
                        title: 'Goal Progress',
                        value: '$_completionPercent%',
                        subtitle: 'Completion against today’s goal',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Today’s Progress',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_completionPercent% complete',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _todayGoalMl <= 0
                              ? 0
                              : (_todayIntakeMl / _todayGoalMl).clamp(0.0, 1.0),
                          minHeight: 10,
                          backgroundColor: const Color(0xFFD8EEF4),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF2F45FF),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$_todayIntakeMl ml logged out of $_todayGoalMl ml goal.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Over Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: _rangeSummaryTitle,
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: [
                        _SummaryCard(
                          title: 'Days Logged',
                          value: '$_daysLogged',
                          subtitle: 'Days with hydration data in this range',
                        ),
                        _SummaryCard(
                          title: 'Goal Hits',
                          value: '$_dailyGoalHits',
                          subtitle: _dailyGoalHitsSubtitle,
                        ),
                        _SummaryCard(
                          title: 'Average Intake',
                          value: '$_averageIntakeMl ml',
                          subtitle: 'Average intake per logged day',
                        ),
                        _SummaryCard(
                          title: 'Total Intake',
                          value: '$_totalIntakeMl ml',
                          subtitle: 'Total water logged in this range',
                        ),
                        _SummaryCard(
                          title: 'Goal Hit Rate',
                          value: '$_goalHitRatePercent%',
                          subtitle: 'Percent of logged days where goal was hit',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: _historySectionTitle,
                    child: filteredEntries.isEmpty
                        ? const Text(
                            'No hydration history available for this range yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Column(
                            children: filteredEntries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _HistoryTile(
                                  entry: _HistoryTileEntry(
                                    label: _formatEntryLabel(entry.date),
                                    intakeMl: entry.intakeMl,
                                    goalMl: entry.goalMl,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            currentIndex: 3,
            onTap: (index) {
              if (index == 3) return;

              if (index == 0) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
                return;
              }

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final _HistoryTileEntry entry;

  String get _statusText {
    final difference = entry.intakeMl - entry.goalMl;

    if (difference == 0) {
      return 'Goal hit';
    }
    if (difference > 0) {
      return '$difference ml over goal';
    }
    return '${-difference} ml short';
  }

  Color get _statusColor {
    if (entry.intakeMl >= entry.goalMl) {
      return const Color(0xFF2E7D32);
    }
    return const Color(0xFFB26A00);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D3557),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${entry.intakeMl} / ${entry.goalMl} ml',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D3557),
              ),
            ),
          ),
          Expanded(
            child: Text(
              _statusText,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTileEntry {
  final String label;
  final int intakeMl;
  final int goalMl;

  const _HistoryTileEntry({
    required this.label,
    required this.intakeMl,
    required this.goalMl,
  });
}
