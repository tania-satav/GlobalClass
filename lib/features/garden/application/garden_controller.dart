/*import 'package:flutter/material.dart';
import '../../home/water_intake_controller.dart';

// === YOUR EXISTING CODE ===
enum PlantStage {
  emptySoil,
  bud,
  growing,
  blooming,
  fullFlower,
}

class GardenPlant {
  final String id;
  final String name;
  final DateTime plantedDate;
  final PlantStage currentStage;
  final int hydrationPercentage;
  
  GardenPlant({
    required this.id,
    required this.name,
    required this.plantedDate,
    required this.currentStage,
    required this.hydrationPercentage,
  });
  
  factory GardenPlant.empty() {
    return GardenPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Plant',
      plantedDate: DateTime.now(),
      currentStage: PlantStage.emptySoil,
      hydrationPercentage: 0,
    );
  }
  
  GardenPlant copyWith({
    String? id,
    String? name,
    DateTime? plantedDate,
    PlantStage? currentStage,
    int? hydrationPercentage,
  }) {
    return GardenPlant(
      id: id ?? this.id,
      name: name ?? this.name,
      plantedDate: plantedDate ?? this.plantedDate,
      currentStage: currentStage ?? this.currentStage,
      hydrationPercentage: hydrationPercentage ?? this.hydrationPercentage,
    );
  }
}

// === ADD THIS CONTROLLER CLASS ===
class GardenController extends ChangeNotifier {
  final WaterIntakeController waterController;
  List<GardenPlant> _plants = [];
  
  GardenController({required this.waterController}) {
    waterController.addListener(_onHydrationChange);
    _loadInitialPlants();
  }
  
  List<GardenPlant> get plants => _plants;
  
  int get hydrationPercentage {
    if (waterController.goalMl == 0) return 0;
    return ((waterController.currentMl / waterController.goalMl) * 100).clamp(0, 100).toInt();
  }
  
  PlantStage getCurrentPlantStage() {
    if (hydrationPercentage < 25) return PlantStage.emptySoil;
    if (hydrationPercentage < 50) return PlantStage.bud;
    if (hydrationPercentage < 75) return PlantStage.growing;
    if (hydrationPercentage < 100) return PlantStage.blooming;
    return PlantStage.fullFlower;
  }
  
  bool _wasGoalJustReached = false;
  
  void _onHydrationChange() {
    final currentPercent = hydrationPercentage;
    
    if (currentPercent >= 100 && !_wasGoalJustReached) {
      _wasGoalJustReached = true;
      _addNewPlant();
    } else if (currentPercent < 100) {
      _wasGoalJustReached = false;
    }
    
    _updateCurrentPlantStage();
    notifyListeners();
  }
  
  void _updateCurrentPlantStage() {
    if (_plants.isEmpty) return;
    
    final currentStage = getCurrentPlantStage();
    final lastIndex = _plants.length - 1;
    
    _plants[lastIndex] = _plants[lastIndex].copyWith(
      currentStage: currentStage,
      hydrationPercentage: hydrationPercentage,
    );
  }
  
  void _addNewPlant() {
    final newPlant = GardenPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Plant ${_plants.length + 1}',
      plantedDate: DateTime.now(),
      currentStage: getCurrentPlantStage(),
      hydrationPercentage: hydrationPercentage,
    );
    
    _plants.add(newPlant);
    _savePlantsToStorage();
  }
  
  void _loadInitialPlants() {
    _plants = _loadFromStorage();
    if (_plants.isEmpty) {
      _plants.add(GardenPlant.empty());
    }
    _updateCurrentPlantStage();
  }
  
  void _savePlantsToStorage() {
    // TODO: Implement storage
    debugPrint('Saved ${_plants.length} plants');
  }
  
  List<GardenPlant> _loadFromStorage() {
    // TODO: Load from storage
    return [];
  }
  
  @override
  void dispose() {
    waterController.removeListener(_onHydrationChange);
    super.dispose();
  }
}
*/