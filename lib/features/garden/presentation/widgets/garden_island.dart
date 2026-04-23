import 'dart:math';
import 'package:flutter/material.dart';

import '../../domain/garden_day.dart';
import '../utils/flower_stage_utils.dart';

class GardenIsland extends StatelessWidget {
  final List<GardenDay> days;

  const GardenIsland({
    super.key,
    required this.days,
  });

  static const double islandWidth =
      370;

  static const double flowerSize =
      45;

  static const List<Offset>
      safeSpots = [
    Offset(185, 190),

    Offset(150, 165),
    Offset(220, 165),

    Offset(120, 140),
    Offset(185, 140),
    Offset(250, 140),

    Offset(150, 115),
    Offset(220, 115),

    Offset(185, 90),
  ];

  List<Offset> _assignPositions(
      int count) {
    final random =
        Random(count * 999);

    final shuffled =
        List<Offset>.from(safeSpots)
          ..shuffle(random);

    return shuffled
        .take(count)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final positions =
        _assignPositions(days.length);

    return Center(
      child: Stack(
        alignment:
            Alignment.bottomCenter,
        children: [
          Image.asset(
            "assets/grass.png",
            width: islandWidth,
            fit: BoxFit.cover,
          ),

          ...List.generate(
            days.length,
            (index) {
              if (index >=
                  positions.length) {
                return const SizedBox();
              }

              final day =
                  days[index];

              final asset =
                  FlowerStageUtils
                      .getPlantAsset(
                intakeMl:
                    day.intakeMl,
                goalMl:
                    day.goalMl,
                flowerType:
                    day.flowerType,
              );

              final center =
                  positions[index];

              return Positioned(
                left: center.dx -
                    flowerSize / 2,
                bottom: center.dy -
                    flowerSize / 2,
                child: Image.asset(
                  asset,
                  width: flowerSize,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}