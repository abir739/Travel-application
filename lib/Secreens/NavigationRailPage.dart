import 'package:flutter/material.dart';
import 'package:zenify_trip/Secreens/guidPlannig.dart';
import 'Profile/MainProfile.dart';
import 'PushNotificationScreen.dart';

import 'ConcentricAnimationOnboarding.dart';

class NavigationRailPage extends StatefulWidget {
  const NavigationRailPage({Key? key}) : super(key: key);

  @override
  State<NavigationRailPage> createState() => _NavigationRailPageState();
}

Widget _PushNotificationScreenState = const PushNotificationScreen();
Widget _planningScreenContent = const PlaningSecreen();
Widget _mainProfileScreenContent = const MainProfile();
Widget _concentricAnimationOnboardingScreenContent =
    const ConcentricAnimationOnboarding();
const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.bookmark_border_outlined),
    activeIcon: Icon(Icons.bookmark_rounded),
    label: 'Bookmarks',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.notifications_active),
    activeIcon: Icon(Icons.notifications_active),
    label: 'Notification',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.more_vert),
    activeIcon: Icon(Icons.more_vert),
    label: 'More',
  ),
];

class _NavigationRailPageState extends State<NavigationRailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              items: _navBarItems,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              })
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: isLargeScreen,
              destinations: _navBarItems
                  .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.activeIcon,
                      label: Text(
                        item.label!,
                      )))
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _selectedIndex == 0
                ? _planningScreenContent
                : _selectedIndex == 2
                    ? _mainProfileScreenContent
                    : _selectedIndex == 1
                        ? _concentricAnimationOnboardingScreenContent
                        : Center(
                            child: Text(
                                "${_navBarItems[_selectedIndex].label} Page")),
          )
        ],
      ),
    );
  }
}
