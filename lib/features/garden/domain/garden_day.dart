enum FlowerType {
  sunflower,
  blueflower,
  redflower,
  purpleflower,
}

class GardenDay {
  final DateTime date;
  final int intakeMl;
  final int goalMl;
  final FlowerType flowerType;

  GardenDay({
    required this.date,
    required this.intakeMl,
    required this.goalMl,
    required this.flowerType,
  });
}