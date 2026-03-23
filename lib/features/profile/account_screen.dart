import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/widgets/home_bottom_nav.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email available';
    final displayName = user?.displayName ?? 'Hydrated User';
    final providerName = _getProviderName(user);

    return Scaffold(
      backgroundColor: const Color(0xFFAEDFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAEDFEA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ACCOUNT',
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
                const SizedBox(height: 8),
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.manage_accounts,
                    size: 58,
                    color: Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your login details and account settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                _InfoCard(
                  title: 'Login Details',
                  children: [
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.login_outlined,
                      label: 'Sign-in method',
                      value: providerName,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ActionCard(
                  icon: Icons.lock_reset,
                  title: 'Reset Password',
                  subtitle: 'Send a password reset email to your account',
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);

                    if (user?.email == null) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('No email found for this account.'),
                        ),
                      );
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: user!.email!,
                      );

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password reset email sent to ${user.email}',
                          ),
                        ),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Could not send password reset email.'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                _ActionCard(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Log out of your account on this device',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
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
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  String _getProviderName(User? user) {
    if (user == null || user.providerData.isEmpty) {
      return 'Email / Password';
    }

    final providerId = user.providerData.first.providerId;

    switch (providerId) {
      case 'password':
        return 'Email / Password';
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      default:
        return providerId;
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1D3557), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D3557),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
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
