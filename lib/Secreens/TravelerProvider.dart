import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenify_trip/login/login_Page.dart';
import 'package:zenify_trip/modele/httpTravellerbyid.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';

class TravelerProvider with ChangeNotifier {
  int notificationCount = 0;
  String userId = '';
  String groupid = "rrqegrgr"; // Initialize as a Future with a default value
  Traveller? traveler;
  final HTTPHandlerTravellerbyId Travelleruserid = HTTPHandlerTravellerbyId();
  late SharedPreferences prefs; // Use 'late' for late initialization

  // Setter for groupid
  set groupids(String newName) {
    groupid = newName;
    notifyListeners();
  }

  Future<String?> loadTravelerData() async {
    try {
      // Replace this logic with your data fetching code
      userId = await storage.read(key: "id") ?? "";
      print("userid from provider $userId");
      final travelerDetail = await Travelleruserid.fetchData(
          "/api/travellers/UserId/$userId");

      groupid = travelerDetail.touristGroupId ?? "hhh";
      traveler = travelerDetail;

      // Initialize prefs
      prefs = await SharedPreferences.getInstance();

      notificationCount = prefs.getInt('notificationCount') ?? 0;

      notifyListeners();
   
    } catch (error) {
      print("ErrorError  traveler data: $error");
      // Handle the error as needed (e.g., show an error message).
    }
    return groupid;
  }
}
