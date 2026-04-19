import 'package:flutter/material.dart';

class FlowerTile extends StatelessWidget {
  final int currentMl;

  const FlowerTile({
    super.key,
    required this.currentMl,
  });

  String getPlantImage() {
    if (currentMl >= 2000) {
      return "assets/plants/flower.png";
    }

    if (currentMl >= 1500) {
      return "assets/plants/growing.png";
    }

    if (currentMl >= 1000) {
      return "assets/plants/sprout.png";
    }

    if (currentMl >= 500) {
      return "assets/plants/bulb.png";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = getPlantImage();

    if (imagePath.isEmpty) {
      return const SizedBox();
    }

    return Image.asset(
      imagePath,
      width: 60,
      height: 60,
    );
  }
}