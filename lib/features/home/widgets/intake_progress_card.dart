import 'package:flutter/material.dart';

class IntakeProgressCard extends StatelessWidget {
  final int goalMl;
  final int currentMl;

  const IntakeProgressCard({
    super.key,
    required this.goalMl,
    required this.currentMl,
  });

  String _formatLabel(int value) {
    return '${value}ml';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = goalMl == 0
        ? 0
        : (currentMl / goalMl).clamp(0.0, 1.0);

    final int topLabel = 0;
    final int rightLabel = (goalMl / 3).round();
    final int bottomLabel = ((goalMl * 2) / 3).round();
    final int leftLabel = goalMl;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 26,
              backgroundColor: const Color(0xFF8ED0E0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF2F45FF)),
            ),
          ),

          Positioned(
            top: 18,
            child: Text(_formatLabel(topLabel), style: _labelStyle),
          ),
          Positioned(
            right: 10,
            child: Text(_formatLabel(rightLabel), style: _labelStyle),
          ),
          Positioned(
            bottom: 12,
            child: Text(_formatLabel(bottomLabel), style: _labelStyle),
          ),
          Positioned(
            left: 8,
            child: Text(_formatLabel(leftLabel), style: _labelStyle),
          ),

          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(120),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_florist,
                  size: 56,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 10),
                Text(
                  '$currentMl / $goalMl ml',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D3557),
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

const _labelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
