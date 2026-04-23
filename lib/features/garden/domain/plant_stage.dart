enum PlantStage {
  empty,
  sprout,
  growing,
  flower,
}

PlantStage getPlantStage({
  required int intake,
  required int goal,
}) {
  if (goal == 0 || intake == 0) {
    return PlantStage.empty;
  }

  final progress = intake / goal;

  if (progress < 0.25) {
    return PlantStage.sprout;
  }

  if (progress < 0.75) {
    return PlantStage.growing;
  }

  return PlantStage.flower;
}