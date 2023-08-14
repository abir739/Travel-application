import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../Profile/MainProfile.dart';
import '../guidPlannig.dart';
import '../ConcentricAnimationOnboarding.dart';
import 'package:flutter_svg/svg.dart';

class GoogleBottomBar extends StatefulWidget {
  const GoogleBottomBar({Key? key}) : super(key: key);

  @override
  State<GoogleBottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<GoogleBottomBar> {
  Widget _planningScreenContent = PlaningSecreen();
  Widget _mainProfileScreenContent = MainProfile();
  Widget _concentricAnimationOnboardingScreenContent =
      const ConcentricAnimationOnboarding();
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    PlaningSecreen(),
    // Add your other screen widgets here
    MainProfile(),
    ConcentricAnimationOnboarding(),
    MainProfile(),
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
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: const Color.fromARGB(255, 68, 5, 150),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.calendar_month),
    title: const Text("Calendar"),
    selectedColor: Color.fromARGB(255, 65, 30, 219),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.search),
    title: const Text("Search"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Profile"),
    selectedColor: Colors.teal,
  ),
];
