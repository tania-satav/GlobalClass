import 'package:flutter/material.dart';

import '../../home/home_screen.dart';
import '../../home/widgets/home_bottom_nav.dart';
import '../../profile/profile_screen.dart';
import '../../stats/stats_screen.dart';
import '../../streaks/streaks_screen.dart';

import 'widgets/garden_header.dart';
import 'widgets/growable_flowers_bar.dart';
import 'widgets/garden_island.dart';
import 'widgets/weekly_garden_row.dart';

import '../application/garden_controller.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  late final GardenController controller;

  @override
  void initState() {
    super.initState();

    controller = GardenController();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 2) return; // Garden (current screen)

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

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StreaksScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StatsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD6F1F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFD6F1F7),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper3.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const GardenHeader(),

              const SizedBox(height: 10),

              const GrowableFlowersBar(),

              const SizedBox(height: 16),

              // Main content area (no scrolling)
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Garden Island fills remaining space
                    Expanded(
                      child: GardenIsland(
                        days: controller.days,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Weekly Progress Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0A7DAC),
                              ),
                            ),

                            SizedBox(height: 12),

                            WeeklyGardenRow(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: HomeBottomNav(
        currentIndex: 2,
        onTap: (index) => _handleNavTap(context, index),
      ),
    );
  }
}