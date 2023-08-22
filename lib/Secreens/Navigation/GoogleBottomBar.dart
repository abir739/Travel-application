import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../modele/TouristGuide.dart';
import '../../modele/planningmainModel.dart';

import '../MyCalendarPage.dart';
import '../Notification/PushNotificationScreen.dart';

import '../Profile/editprofile.dart';
import '../guidPlannig.dart';
import '../ConcentricAnimationOnboarding.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class GoogleBottomBar extends StatefulWidget {
  const GoogleBottomBar({Key? key}) : super(key: key);

  @override
  State<GoogleBottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<GoogleBottomBar> {
  TouristGuide? selectedTouristGuide = TouristGuide();
  PlanningMainModel? selectedPlanning = PlanningMainModel();

  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const PlaningSecreen(),
    const MyCalendarPage(),
    MainProfile(),
    PushNotificationScreen(),
    const ConcentricAnimationOnboarding(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: Row(
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Zenify', // Your text
                  textStyle: const TextStyle(
                    fontSize: 26,
                    letterSpacing: 24,
                    color: Color.fromARGB(255, 68, 5, 150),
                  ),
                  speed: const Duration(
                      milliseconds: 200), // Adjust the animation speed
                ),
              ],
              totalRepeatCount:
                  5, // Set the number of times the animation will repeat
              pause: const Duration(
                  milliseconds: 1000), // Duration before animation starts again
              displayFullTextOnTap: true, // Display full text when tapped
            ),
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
          ],
        ),
      ),
      body: Center(
        child: _screens[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        backgroundColor: const Color.fromARGB(244, 78, 3, 73),
        buttonBackgroundColor: Colors.white,
        color: Colors.white,
        animationCurve: Curves.easeInOut,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_month, size: 30),
          // Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.notifications_active, size: 30),
          Icon(Icons.more_vert, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
