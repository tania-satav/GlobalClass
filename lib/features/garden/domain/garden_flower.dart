import 'plant_stage.dart';

/// 🌿 Plant stage → image mapping (keep as-is)
String getPlantImage(PlantStage stage) {
  switch (stage) {
    case PlantStage.empty:
      return 'assets/plants/soil.png';

    case PlantStage.sprout:
      return 'assets/plants/sprout.png';

    case PlantStage.growing:
      return 'assets/plants/growing.png';

    case PlantStage.flower:
      return 'assets/plants/flower.png';
  }
}

/// 🌸 FLOWER TYPE (NEW FIX)
enum FlowerType {
  sunflower,
  blueflower,
  redflower,
  purpleflower,
}

/// 🌿 MAIN MODEL
class GardenFlower {
  final String id;
  final DateTime createdAt;
  final int waterAmount;

  /// 🌸 NEW: stores which flower was generated
  final FlowerType flowerType;

  GardenFlower({
    required this.id,
    required this.createdAt,
    required this.waterAmount,
    required this.flowerType,
  });

  /// 🌼 helper: convert type → asset
  String get image {
    switch (flowerType) {
      case FlowerType.sunflower:
        return 'assets/plants/sunflower.png';

      case FlowerType.blueflower:
        return 'assets/plants/blueflower.png';

      case FlowerType.redflower:
        return 'assets/plants/redflower.png';

      case FlowerType.purpleflower:
        return 'assets/plants/purpleflower.png';
    }
  }
}