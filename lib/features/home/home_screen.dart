import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../streaks/streaks_screen.dart';
import 'widgets/intake_progress_card.dart';
import 'widgets/did_you_know_card.dart';
import 'widgets/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int goalMl = 1500;
    const int currentMl = 650;

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
          children: const [
            SizedBox(height: 14),
            _Title(),
            SizedBox(height: 18),
            IntakeProgressCard(goalMl: goalMl, currentMl: currentMl),
            SizedBox(height: 18),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: DidYouKnowCard(),
            ),
            Spacer(),
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
              MaterialPageRoute(builder: (context) => const StreaksScreen()),
            );
          }
        },
      ),
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
