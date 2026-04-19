import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/widgets/home_bottom_nav.dart';
import '../../home/home_screen.dart';
import '../../home/water_intake_controller.dart';
import '../../profile/profile_screen.dart';
import '../../stats/stats_screen.dart';
import '../../streaks/streaks_screen.dart';

import 'widgets/garden_header.dart';
import 'widgets/garden_tabs.dart';
import 'widgets/garden_island.dart';
import 'widgets/recent_activity_list.dart';
import 'widgets/growable_flowers_bar.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
  
}

class _GardenScreenState extends State<GardenScreen> {
  
  void _handleNavTap(BuildContext context, int index) {
    if (index == 3) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatsScreen()),
      );
      return;
    }
  }
/*
  //SINGLE SOURCE OF TRUTH: growth stage
  int _getGrowthStage(int ml) {
    if (ml < 500) return 0;   // seed
    if (ml < 1000) return 1;  // sprout
    if (ml < 1500) return 2;  // growing
    if (ml < 2000) return 3;  // flower stage
    return 4;                 // full bloom
  }

  // MESSAGE (NOW MATCHES STAGES EXACTLY)
  String _getGrowthMessage(int ml) {
    switch (_getGrowthStage(ml)) {
      case 0:
        return 'Plant a seed by drinking water!';
      case 1:
        return 'A sprout is growing!';
      case 2:
        return 'Your plant is developing beautifully!';
      case 3:
        return 'Almost fully grown!';
      default:
        return 'Your garden has bloomed!';
    }
  }

  // COLOR (MATCHES STAGES)
  Color _getProgressColor(int ml) {
    switch (_getGrowthStage(ml)) {
      case 0:
        return Colors.brown;
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.pink;
      default:
        return Colors.red;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final waterController = context.watch<WaterIntakeController>();

    final currentMl = waterController.currentMl;
    final goalMl = waterController.goalMl;

    //final progress = goalMl == 0 ? 0.0 : (currentMl / goalMl).clamp(0.0, 1.0);

    return Scaffold(
            backgroundColor: Color(0xFFAEDFEA),

      appBar: AppBar(
  backgroundColor: const Color(0xFFAEDFEA),
  elevation: 0,
  automaticallyImplyLeading: false,
),

      body: SafeArea(
        child: Column(
          children: [
            const GardenHeader(),
            const SizedBox(height: 10),
            //const GardenTabs(),
            const GrowableFlowersBar(),

const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //GARDEN VISUAL
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 350,
                        child: GardenIsland(),
                      ),
                    ),

                    const SizedBox(height: 10),
/*
                    // MESSAGE
                    Text(
                      _getGrowthMessage(currentMl),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    //PROGRESS BAR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: _getProgressColor(currentMl),
                        minHeight: 10,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ML DISPLAY
                    Text(
                      '$currentMl / $goalMl ml',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
*/
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            //const RecentActivityList(),
          ],
        ),
      ),

      bottomNavigationBar: HomeBottomNav(
        currentIndex: 3,
        onTap: (index) => _handleNavTap(context, index),
        
      ),
    );
  }
}

