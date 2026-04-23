import 'package:flutter/material.dart';
import '../profile/hydration_settings.dart';
import '../profile/profile_screen.dart';
import '../stats/stats_screen.dart';
import '../streaks/streaks_screen.dart';
import 'today_hydration_state.dart';
import 'water_intake_controller.dart';
import 'widgets/did_you_know_card.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/intake_progress_card.dart';
import '../garden/presentation/garden_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.initialGoalMl = 1500,
    this.initialCurrentMl = 650,
  });

  final int initialGoalMl;
  final int initialCurrentMl;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WaterIntakeController controller;
  final HydrationSettings settings = HydrationSettings.instance;
  final TodayHydrationState todayHydrationState = TodayHydrationState.instance;
  final TextEditingController _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = WaterIntakeController(
      goalMl: settings.dailyGoalMl,
      currentMl: 0,
    );

    settings.addListener(_syncGoalFromSettings);
    controller.addListener(_syncTodayIntakeFromController);

    _initializeTodayState();
  }

  Future<void> _initializeTodayState() async {
    await todayHydrationState.loadToday(goalMl: settings.dailyGoalMl);

    controller.loadState(
      goalMl: settings.dailyGoalMl,
      currentMl: todayHydrationState.currentIntakeMl,
    );
  }

  void _syncGoalFromSettings() {
    controller.updateGoal(settings.dailyGoalMl);
    _syncTodayIntakeFromController();
  }

  Future<void> _syncTodayIntakeFromController() async {
    await todayHydrationState.setCurrentIntake(
      value: controller.currentMl,
      goalMl: controller.goalMl,
    );
  }

  Future<void> _addWater(int amount) async {
    controller.addWater(amount);
  }

  Future<void> _removeWater(int amount) async {
    controller.removeWater(amount);
  }

  Future<void> _resetWater() async {
    controller.resetWater();
  }

  Future<void> _addCustomWater() async {
    final rawValue = _customAmountController.text.trim();
    final parsedAmount = int.tryParse(rawValue);

    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid custom amount greater than 0 ml.'),
        ),
      );
      return;
    }

    if (parsedAmount > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Custom amount should be 5000 ml or less.'),
        ),
      );
      return;
    }

    await _addWater(parsedAmount);
    _customAmountController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$parsedAmount ml added to today\'s intake.')),
    );
  }

  void _handleNavTap(int index) {
    if (index == 1) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GardenScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StreaksScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatsScreen()),
      );
      return;
    }
  }

  @override
  void dispose() {
    settings.removeListener(_syncGoalFromSettings);
    controller.removeListener(_syncTodayIntakeFromController);
    _customAmountController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, todayHydrationState]),
      builder: (context, _) {
        if (!todayHydrationState.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFD6F1F7),
          appBar: AppBar(
            backgroundColor: const Color(0xFFD6F1F7),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF4A9FB5),
                  size: 26,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper3.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    const _Title(),
                    const SizedBox(height: 18),
                    IntakeProgressCard(
                      goalMl: controller.goalMl,
                      currentMl: controller.currentMl,
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: () => _addWater(250),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1D3557),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              '+250ml',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _addWater(500),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1D3557),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              '+500ml',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _removeWater(250),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1D3557),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              '-250ml',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _resetWater,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A7DAC),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Custom Water Intake',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Enter your own amount in ml and add it to today’s intake.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Enter amount',
                                      filled: true,
                                      fillColor: const Color(0xFFF7FBFD),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
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
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _addCustomWater,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A7DAC),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Add Custom Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: DidYouKnowCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            currentIndex: 1,
            onTap: _handleNavTap,
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'YOUR DAILY',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Color(0xFF1D3557),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'INTAKE',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Color(0xFF1D3557),
          ),
        ),
      ],
    );
  }
}