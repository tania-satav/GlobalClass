import '../../domain/garden_day.dart';

class FlowerStageUtils {
  static String getPlantAsset({
    required int intakeMl,
    required int goalMl,
    required FlowerType flowerType,
    bool isFuture = false,
  }) {
    if (isFuture) {
      return "assets/plants/empty.png";
    }

    if (goalMl <= 0) {
      return "assets/plants/empty.png";
    }

    final progress =
        intakeMl / goalMl;

    // 100%
    if (progress >= 1.0) {
      return _flowerAsset(
          flowerType);
    }

    // 75%
    if (progress >= 0.75) {
      return "assets/plants/growing.png";
    }

    // 50%
    if (progress >= 0.50) {
      return "assets/plants/sprout.png";
    }

    // 25%
    if (progress >= 0.25) {
      return "assets/plants/bulb.png";
    }

    return "assets/plants/empty.png";
  }

  static String _flowerAsset(
      FlowerType type) {
    switch (type) {
      case FlowerType.sunflower:
        return "assets/plants/sunflower.png";

      case FlowerType.blueflower:
        return "assets/plants/blueflower.png";

      case FlowerType.redflower:
        return "assets/plants/redflower.png";

      case FlowerType.purpleflower:
        return "assets/plants/purpleflower.png";
    }
  }
}