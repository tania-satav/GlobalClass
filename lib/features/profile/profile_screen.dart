import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../home/widgets/home_bottom_nav.dart';
import '../stats/stats_screen.dart';
import '../streaks/streaks_screen.dart';
import 'account_screen.dart';
import 'personalisation_screen.dart';
import 'reminders_screen.dart';
import '../garden/presentation/garden_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _openScreen(BuildContext context, Widget screen) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  void _handleNavTap(int index) {
    if (index == 0) return;

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
    return Scaffold(
      backgroundColor: const Color(0xFFAEDFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAEDFEA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage your account and hydration preferences',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              _ProfileOptionCard(
                icon: Icons.manage_accounts_outlined,
                title: 'Account',
                subtitle: 'Login details, email, password reset and sign out',
                onTap: () {
                  _openScreen(context, const AccountScreen());
                },
              ),
              const SizedBox(height: 16),
              _ProfileOptionCard(
                icon: Icons.tune_outlined,
                title: 'Personalisation',
                subtitle: 'Weight, activity level, daily goal and units',
                onTap: () {
                  _openScreen(context, const PersonalisationScreen());
                },
              ),
              const SizedBox(height: 16),
              _ProfileOptionCard(
                icon: Icons.notifications_active_outlined,
                title: 'Reminders',
                subtitle: 'Notification frequency, timing and quiet hours',
                onTap: () {
                  _openScreen(context, const RemindersScreen());
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 0, onTap: _handleNavTap),
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  const _ProfileOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFF1D3557), size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF1D3557),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
