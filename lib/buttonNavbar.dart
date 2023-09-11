import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenify_trip/Secreens/AccommodationSecreen.dart';
import 'package:zenify_trip/guide_Screens/firstpage.dart';
import 'Secreens/ConcentricAnimationOnboarding.dart';
import 'Secreens/Notification/PushNotificationScreen.dart';
import 'Secreens/Profile/editprofile.dart';

import 'modele/TouristGuide.dart';
import 'modele/planningmainModel.dart'; // Import the necessary package

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  get selectedPlanning => PlanningMainModel();

  TouristGuide? get selectedTouristGuide => TouristGuide();
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 50.0,
      backgroundColor: const Color.fromARGB(244, 78, 3, 73),
      buttonBackgroundColor: Colors.white,
      color: Colors.white,
      animationCurve: Curves.easeInOut,
      items: const <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.calendar_month, size: 30),
        Icon(Icons.person, size: 30),
        Icon(Icons.notifications_active, size: 30),
        Icon(Icons.more_vert, size: 30),
      ],
      onTap: (index) {
        // Handle navigation based on the selected index
        switch (index) {
          case 0:
            Get.to(const PlaningSecreen()); // Navigate to the home page
            break;
          case 1:
            Get.to(PlanningScreen(selectedPlanning!.id,
                selectedTouristGuide)); // Navigate to the calendar page
            break;
          case 2:
            Get.to(const MainProfile()); // Navigate to the profile page
            break;
          case 3:
            Get.to(
                const PushNotificationScreen()); // Navigate to the notifications page
            break;
          case 4:
            Get.to(
                const ConcentricAnimationOnboarding()); // Navigate to the more options page
            break;
        }
      },
    );
  }
}
