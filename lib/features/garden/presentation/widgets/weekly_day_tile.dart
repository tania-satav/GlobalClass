import 'package:flutter/material.dart';

import '../../domain/garden_day.dart';
import '../utils/flower_stage_utils.dart';

class WeeklyDayTile extends StatelessWidget {
  final int intakeMl;
  final int goalMl;
  final bool isFuture;
  final String label;
  final FlowerType flowerType;

  const WeeklyDayTile({
    super.key,
    required this.intakeMl,
    required this.goalMl,
    required this.isFuture,
    required this.label,
    required this.flowerType,
  });

  @override
  Widget build(BuildContext context) {
    final asset =
        FlowerStageUtils.getPlantAsset(
      intakeMl: intakeMl,
      goalMl: goalMl,
      flowerType: flowerType,
      isFuture: isFuture,
    );

return SizedBox(
  height: 70, // ensures all tiles share the same height
  child: Column(
    children: [
      Expanded(
        child: Center(
          child: Image.asset(
            asset,
            width: 40,
          ),
        ),
      ),

      const SizedBox(height: 6),

      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
);
  }
}