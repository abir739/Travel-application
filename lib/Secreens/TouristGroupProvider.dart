import 'package:flutter/material.dart';

import '../modele/planningmainModel.dart';
import '../modele/touristGroup.dart';

class TouristGroupProvider extends ChangeNotifier {
 

  TouristGroup? _selectedTouristGroup;
  PlanningMainModel? _selectedPlanning;

  PlanningMainModel? get selectedPlanning => _selectedPlanning;
  TouristGroup? get selectedTouristGroup => _selectedTouristGroup;

  set selectedPlanning(PlanningMainModel? value) {
    _selectedPlanning = value;
    notifyListeners();
  }

  set selectedTouristGroup(TouristGroup? value) {
    _selectedTouristGroup = value;
    notifyListeners();
  }

  void updateSelectedTouristGroup(TouristGroup newValue) {
    selectedTouristGroup = newValue;
    // Additional logic you want to perform when the tourist group is updated
    notifyListeners();
  }

  void updateSelectedPlanning(PlanningMainModel newValue) {
    selectedPlanning = newValue;
    // Additional logic you want to perform when the planning is updated
    notifyListeners();
  }
}
