import 'dart:async';
import 'package:flutter/material.dart';

class DidYouKnowCard extends StatefulWidget {
  const DidYouKnowCard({super.key});

  @override
  State<DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<DidYouKnowCard>
    with SingleTickerProviderStateMixin {
  final List<String> _facts = const [
    "Your brain is ~73% water. Even mild dehydration can cause brain fog.",
    "Drinking water boosts energy and focus within minutes.",
    "Your body is about 60% water.",
    "Water helps regulate your body temperature.",
    "Dehydration can affect your mood and concentration.",
    "Drinking water helps improve skin health and glow.",
  ];

  int _index = 0;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _controller.reverse();

      setState(() {
        _index = (_index + 1) % _facts.length;
      });

      await _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Container(
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
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Did you know?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    _facts[_index],
                    style: const TextStyle(
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
      ),
    );
  }
}