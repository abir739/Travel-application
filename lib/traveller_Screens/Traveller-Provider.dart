import 'package:flutter/material.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';

class TravellerProvider extends ChangeNotifier {
  Traveller? _traveller;

  Traveller? get traveller => _traveller;

  void setTraveller(Traveller traveller) {
    _traveller = traveller;
    notifyListeners();
  }
}
