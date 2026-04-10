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
        MaterialPageRoute(builder: (context) => const StreaksScreen()),
      );
      return;
    }

    if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Garden screen is not connected yet.')),
      );
      return;
    }

    if (index == 4) {
      Navigator.pushReplacement(
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
            backgroundColor: Color(0xFFAEDFEA),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFAEDFEA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFAEDFEA),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
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
                          style: TextStyle(fontWeight: FontWeight.w700),
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
                          style: TextStyle(fontWeight: FontWeight.w700),
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
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _resetWater,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F45FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: DidYouKnowCard(),
                ),
                const Spacer(),
              ],
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
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'INTAKE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
