class GardenFlower {
  final String id;
  final DateTime createdAt;
  final int waterAmount; // snapshot that unlocked it

  GardenFlower({
    required this.id,
    required this.createdAt,
    required this.waterAmount,
  });
}