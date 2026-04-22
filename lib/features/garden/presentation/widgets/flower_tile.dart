import 'package:flutter/material.dart';
import '../../domain/plant_stage.dart';

class FlowerTile extends StatelessWidget {
  final double progress;

  const FlowerTile({
    super.key,
    required this.progress,
  });

  PlantStage getStage() {
    if (progress <= 0) {
      return PlantStage.empty;
    }

    if (progress < 0.25) {
      return PlantStage.sprout;
    }

    if (progress < 0.75) {
      return PlantStage.growing;
    }

    return PlantStage.flower;
  }

  String getPlantImage(PlantStage stage) {
    switch (stage) {
      case PlantStage.empty:
        return "assets/plants/bulb.png";

      case PlantStage.sprout:
        return "assets/plants/sprout.png";

      case PlantStage.growing:
        return "assets/plants/growing.png";

      case PlantStage.flower:
        return "assets/plants/sunflower.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = getStage();
    final imagePath = getPlantImage(stage);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Image.asset(
        imagePath,
        width: 65,
        height: 65,
        fit: BoxFit.contain,
      ),
    );
  }
}