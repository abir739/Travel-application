import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenify_trip/login/login_Page.dart';

import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/httpTouristguidByid.dart';
import 'package:zenify_trip/modele/httpTravellerbyid.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';

class guidProvider with ChangeNotifier {
  int notificationCount = 0;
  String userId = '';
  String groupid = "rrqegrgr"; // Initialize as a Future with a default value
  String guidid = "guidid"; // Initialize as a Future with a default value
  Traveller? traveler;
  final HTTPHandlerTravellerbyId Travelleruserid = HTTPHandlerTravellerbyId();
  late SharedPreferences prefs; // Use 'late' for late initialization
  final guidbyuserid = HTTPHandlerToristGuidbyId();
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
      final travelerDetail =
          await Travelleruserid.fetchData("/api/travellers/UserId/$userId");

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

  Future<String?> loadDataGuid() async {
    final userId = await storage.read(key: "id");
    // String? accessToken = await getAccessToken();
    // print('${widget.token} token');
    final toristguiddetail =
        await guidbyuserid.fetchData("/api/tourist-guides/UserIds/$userId");
    guidid = toristguiddetail.id??'null';
    prefs = await SharedPreferences.getInstance();

    notificationCount = prefs.getInt('notificationCount') ?? 0;

    notifyListeners();
    return guidid;
  }
   Future<TouristGuide?> loadDataGuidDetail() async {
    final userId = await storage.read(key: "id");
    // String? accessToken = await getAccessToken();
    // print('${widget.token} token');
    final toristguiddetail =
        await guidbyuserid.fetchData("/api/tourist-guides/UserIds/$userId");
 
    prefs = await SharedPreferences.getInstance();

    notificationCount = prefs.getInt('notificationCount') ?? 0;

    notifyListeners();
    return toristguiddetail;
  }
}
