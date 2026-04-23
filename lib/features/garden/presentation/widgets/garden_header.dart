import 'package:flutter/material.dart';

class GardenHeader extends StatelessWidget {
  const GardenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: const Color(0xFF0A7DAC), 
      child: const Center(
        child: Text(
          'YOUR GARDEN',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}