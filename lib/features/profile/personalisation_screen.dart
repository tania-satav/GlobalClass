import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../home/widgets/home_bottom_nav.dart';
import 'hydration_settings.dart';
import 'hydration_settings_storage.dart';

class PersonalisationScreen extends StatefulWidget {
  const PersonalisationScreen({super.key});

  @override
  State<PersonalisationScreen> createState() => _PersonalisationScreenState();
}

class _PersonalisationScreenState extends State<PersonalisationScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _customGoalController;

  late String _selectedActivityLevel;
  late String _selectedUnit;
  late int _dailyGoalMl;

  final HydrationSettings _settings = HydrationSettings.instance;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  static const List<String> _activityLevels = ['Low', 'Medium', 'High'];
  static const List<String> _units = ['ml', 'L'];
  static const List<int> _quickGoalOptions = [1500, 2000, 2500, 3000];

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: _settings.weightKg.toStringAsFixed(
        _settings.weightKg % 1 == 0 ? 0 : 1,
      ),
    );
    _customGoalController = TextEditingController(
      text: _settings.dailyGoalMl.toString(),
    );
    _selectedActivityLevel = _settings.activityLevel;
    _selectedUnit = _settings.unit;
    _dailyGoalMl = _settings.dailyGoalMl;
  }

  int _calculateRecommendedGoal() {
    final double? weightKg = double.tryParse(_weightController.text.trim());

    if (weightKg == null || weightKg <= 0) {
      return 2000;
    }

    double recommendedMl = weightKg * 30;

    switch (_selectedActivityLevel) {
      case 'Low':
        recommendedMl += 0;
        break;
      case 'Medium':
        recommendedMl += 300;
        break;
      case 'High':
        recommendedMl += 700;
        break;
    }

    return recommendedMl.round();
  }

  String _formatLitresExact(int ml) {
    String litres = (ml / 1000).toStringAsFixed(3);
    litres = litres.replaceFirst(RegExp(r'0+$'), '');
    litres = litres.replaceFirst(RegExp(r'\.$'), '');
    return '$litres L';
  }

  String _formatGoal(int ml) {
    if (_selectedUnit == 'L') {
      return _formatLitresExact(ml);
    }
    return '$ml ml';
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _useRecommendedGoal() {
    final recommended = _calculateRecommendedGoal();
    setState(() {
      _dailyGoalMl = recommended;
      _customGoalController.text = recommended.toString();
    });
  }

  void _applyQuickGoal(int goal) {
    setState(() {
      _dailyGoalMl = goal;
      _customGoalController.text = goal.toString();
    });
  }

  void _updateCustomGoal(String value) {
    final parsed = int.tryParse(value.trim());

    if (parsed == null) return;
    if (parsed < 500 || parsed > 6000) return;

    setState(() {
      _dailyGoalMl = parsed;
    });
  }

  void _showActivityInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Activity Level Guide'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Low: little exercise or mostly sedentary days.'),
              SizedBox(height: 10),
              Text('Medium: some activity on most days.'),
              SizedBox(height: 10),
              Text('High: frequent exercise, sport, or a lot of sweating.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePreferences() async {
    final double parsedWeight =
        double.tryParse(_weightController.text.trim()) ?? _settings.weightKg;

    final int parsedGoal =
        int.tryParse(_customGoalController.text.trim()) ?? _dailyGoalMl;

    if (parsedGoal < 500 || parsedGoal > 6000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a daily goal between 500 ml and 6000 ml'),
        ),
      );
      return;
    }

    _dailyGoalMl = parsedGoal;

    _settings.updatePersonalisation(
      weightKg: parsedWeight,
      activityLevel: _selectedActivityLevel,
      unit: _selectedUnit,
      dailyGoalMl: _dailyGoalMl,
    );

    await HydrationSettingsStorage.save(_settings);

    final today = _dateOnly(DateTime.now());
    final todayRow = await _databaseHelper.getDailyIntakeByDate(today);

    if (todayRow != null) {
      await _databaseHelper.upsertDailyIntake(
        intakeDate: today,
        intakeMl: (todayRow['intake_ml'] as int?) ?? 0,
        goalMl: _dailyGoalMl,
      );
    } else {
      await _databaseHelper.ensureDailyIntakeRow(
        intakeDate: today,
        goalMl: _dailyGoalMl,
      );
    }

    if (!mounted) return;
    Navigator.pop(context, 'Personalisation settings saved');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _customGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int recommendedGoalMl = _calculateRecommendedGoal();

    return Scaffold(
      backgroundColor: const Color(0xFFAEDFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAEDFEA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PERSONALISATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _NoStretchScrollBehavior(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _SummaryCard(
                  weight: _weightController.text.isEmpty
                      ? '-'
                      : '${_weightController.text} kg',
                  activityLevel: _selectedActivityLevel,
                  dailyGoal: _formatGoal(_dailyGoalMl),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Personal Details',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weight (kg)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your weight',
                          filled: true,
                          fillColor: const Color(0xFFF7FBFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Text(
                            'Activity Level',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _showActivityInfo,
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.help_outline,
                                size: 18,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedActivityLevel,
                        items: _activityLevels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF7FBFD),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedActivityLevel = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Daily Goal',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended goal: ${_formatGoal(recommendedGoalMl)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Based on your weight and activity level.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _useRecommendedGoal,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1D3557),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Use Recommended Goal',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 18),
                      const Text(
                        'Custom Daily Goal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Prefer your own target? Set it here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customGoalController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter custom goal',
                                filled: true,
                                fillColor: const Color(0xFFF7FBFD),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: _updateCustomGoal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FBFD),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'ml',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _quickGoalOptions.map((goal) {
                          final isSelected = _dailyGoalMl == goal;
                          return ChoiceChip(
                            label: Text('${goal}ml'),
                            selected: isSelected,
                            onSelected: (_) => _applyQuickGoal(goal),
                            selectedColor: const Color(0xFF2F45FF),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1D3557),
                              fontWeight: FontWeight.w700,
                            ),
                            backgroundColor: const Color(0xFFF7FBFD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Current daily goal: ${_formatGoal(_dailyGoalMl)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Units',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose how your intake goal is displayed throughout the app.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<String>(
                        segments: _units.map((unit) {
                          return ButtonSegment<String>(
                            value: unit,
                            label: Text(unit),
                          );
                        }).toList(),
                        selected: {_selectedUnit},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _selectedUnit = selection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _savePreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F45FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Save Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.weight,
    required this.activityLevel,
    required this.dailyGoal,
  });

  final String weight;
  final String activityLevel;
  final String dailyGoal;

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
          const Text(
            'Profile Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 14),
          _SummaryRow(label: 'Weight', value: weight),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Activity', value: activityLevel),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Daily Goal', value: dailyGoal),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1D3557),
          ),
        ),
      ],
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

class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}