import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../streaks/streaks_screen.dart';
import 'water_intake_controller.dart';
import 'widgets/intake_progress_card.dart';
import 'widgets/did_you_know_card.dart';
import 'widgets/home_bottom_nav.dart';

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

  @override
  void initState() {
    super.initState();
    controller = WaterIntakeController(
      goalMl: widget.initialGoalMl,
      currentMl: widget.initialCurrentMl,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFAEDFEA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFAEDFEA),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
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
                        onPressed: () => controller.addWater(250),
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
                        onPressed: () => controller.addWater(500),
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
                        onPressed: () => controller.removeWater(250),
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
                        onPressed: controller.resetWater,
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
            currentIndex: 0,
            onTap: (index) {
              if (index == 0) return;

              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StreaksScreen(),
                  ),
                );
              }
            },
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
