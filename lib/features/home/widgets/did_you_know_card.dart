import 'package:flutter/material.dart';

class DidYouKnowCard extends StatelessWidget {
  const DidYouKnowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
                      'assets/icons/watericonwhite.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Did you know?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D3557),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your brain is ~73% water. Even mild dehydration can cause headaches and brain fog. Drink up to stay sharp!',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A9D8F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
