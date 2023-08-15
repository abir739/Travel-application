import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'ConcentricAnimationOnboarding.dart';
import 'Profile/MainProfile.dart';
import 'PushNotificationScreen.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    
    const ConcentricAnimationOnboarding(),
    MainProfile(),
    PushNotificationScreen(),
    MainProfile(), // Add your other pages here
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
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        backgroundColor: Colors.blueAccent,
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
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
