import 'package:flutter/material.dart';
import 'package:keepmehydrated/features/home/today_hydration_state.dart';

class GardenIsland extends StatelessWidget {
  const GardenIsland({super.key});

String _getPlantAsset(int ml, int variant) {
  if (ml >= 2000) {
    switch (variant) {
      case 0:
        return "assets/plants/sunflower.png";
      case 1:
        return "assets/plants/blueflower.png";
      case 2:
        return "assets/plants/redflower.png";
      case 3:
        return "assets/plants/purpleflower.png";
      default:
        return "assets/plants/sunflower.png";
    }
  }

  if (ml >= 1500) return "assets/plants/growing.png";
  if (ml >= 1000) return "assets/plants/sprout.png";
  if (ml >= 500) return "assets/plants/bulb.png";
  return "";
}

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TodayHydrationState.instance,
      builder: (context, _) {
        final state = TodayHydrationState.instance;

        final ml = state.currentIntakeMl;
        final variant = state.currentFlowerVariant;

        final plantAsset = _getPlantAsset(ml, variant);

        return Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 🌿 Base garden
              Image.asset(
                "assets/grass.png",
                width: 370,
              ),

              // 🌱 Plant
              if (plantAsset.isNotEmpty)
                Positioned(
                  bottom: 100,
                  child: Image.asset(
                    plantAsset,
                    width: 50,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}