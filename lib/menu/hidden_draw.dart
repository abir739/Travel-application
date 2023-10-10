import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import 'package:zenify_trip/Secreens/Notification/notificationlist.dart';
import 'package:zenify_trip/Secreens/TravelerProvider.dart';
import 'package:zenify_trip/Secreens/TravellerCalender.dart';
import 'package:zenify_trip/Settings/SettingsScreen.dart';


import 'package:zenify_trip/modele/traveller/TravellerModel.dart';
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/traveller_Screens/Traveller-First-Screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  final baseStyle = TextStyle(color: Color.fromARGB(255, 22, 21, 21),fontSize: 20,);
  final selectedStyle = TextStyle(
    color: const Color.fromARGB(255, 241, 4, 4),
    fontSize: 30,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final travelerProvider =
        Provider.of<TravelerProvider>(context, listen: false);
    final String? travellergroupId = "";
    final Traveller? traveller = travelerProvider.traveler;
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Home', baseStyle: baseStyle, selectedStyle: selectedStyle),
          TravellerFirstScreen(userList: [],)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Notification',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          NotificationScreen(groupsid: travellergroupId)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Calander',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          TravellerCalendarPage(group: travellergroupId)),
              ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$settingsEmoji settings',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          SettingsScreen()),
// ScreenHiddenDrawer(
      //     ItemHiddenMenu(
      //         name: 'Mywedget',
      //         baseStyle: baseStyle,
      //         selectedStyle: selectedStyle),
      //     Mywedget())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(elevationAppBar :30.0,slidePercent :45.0,verticalScalePercent :90.0,
      backgroundColorMenu: Color.fromARGB(214, 59, 20, 231),
      screens: _pages,
backgroundMenu:DecorationImage(image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      initPositionSelected: 0,boxShadow: [BoxShadow(color: Color.fromARGB(5, 1, 14, 126),offset: Offset.fromDirection(double.maxFinite),blurStyle: BlurStyle.normal)],
    );
  }
}
