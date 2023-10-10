import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import 'package:zenify_trip/Secreens/Notification/PushNotificationScreen.dart';
import 'package:zenify_trip/Secreens/Notification/notificationlist_O.dart';
import 'package:zenify_trip/Secreens/Profile/User_Profil.dart';
// import 'package:zenify_trip/Secreens/Notification/notificationlist.dart';
import 'package:zenify_trip/Settings/SettingsScreen.dart';
import 'package:zenify_trip/guide_Screens/Events-Calendar-Guide.dart';
import 'package:zenify_trip/guide_Screens/Guide_First_Page.dart';
import 'package:zenify_trip/guide_Screens/calendar/Guide_Calendar.dart';
// import 'package:zenify_trip/guide_Screens/GuidCalander_O.dart';
import 'package:zenify_trip/guide_Screens/calendar/filtre__ByGroups.dart';
import 'package:zenify_trip/guide_Screens/guidPlannig.dart';
import 'package:zenify_trip/guide_Screens/tasks/tasks_Calendar.dart';
import 'package:zenify_trip/guide_Screens/travellers_list_screen.dart';
import 'package:zenify_trip/login/login_Page.dart';
// import 'package:zenify_trip/guide_Screens/Guide_First_Page.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/httpTouristguidByid.dart';
import 'package:zenify_trip/routes/SettingsProvider.dart';
import 'package:zenify_trip/services/GuideProvider.dart';
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/theme.dart';

class HiddenDrawerGuid extends StatefulWidget {
  TouristGuide? guid;
  HiddenDrawerGuid(this.guid, {Key? key}) : super(key: key);

  @override
  State<HiddenDrawerGuid> createState() => _HiddenDrawerGuidState();
}

class _HiddenDrawerGuidState extends State<HiddenDrawerGuid> {
  List<ScreenHiddenDrawer> _pages = [];
  String? travellergroupId = "";
  late TouristGuide guid;
  late bool isdark = false;
  final guidbyuserid = HTTPHandlerToristGuidbyId();
  final baseStyle = TextStyle(
    fontSize: 25,
  );
  final selectedStyle = TextStyle(
    fontSize: 30,
  );
  @override
  void initState() {
    super.initState();
    _initializeTravelerData();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: ' 🏠Home',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle,
              colorLineSelected: isdark
                  ? MyThemes.lightTheme.splashColor
                  : MyThemes.darkTheme.splashColor),
          const PlanningSecreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: ' 👤 Profil',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          const MainProfile()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: ' 🔔 Notification',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          NotificationScreen(groupsid: travellergroupId)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$calendarEmoji Events',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          EventCalendar(guideId: widget.guid!.id)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$tasksEmoji Tasks',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          TaskListPage(guideId: widget.guid!.id)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$transportEmoji Transfers',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          PlanningScreen(widget.guid)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$calendarEmoji Filtre Calendar',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          GroupsListScreen(guideId: widget.guid!.id)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$groupsEmoji Travellers List',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          TravellersListScreen(guideId: widget.guid!.id)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$addNotificationEmoji Send Notification',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          PushNotificationScreen(widget.guid)),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: ' $informationsEmoji About',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          const PlaningSecreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: '$settingsEmoji settings',
              baseStyle: baseStyle,
              selectedStyle: selectedStyle),
          SettingsScreen()),
    ];
  }

  Future<void> _initializeTravelerData() async {
    final GuideProvider = Provider.of<guidProvider>(context, listen: false);

    try {
      final result = await GuideProvider.loadDataGuid();

      setState(() {
        travellergroupId = result;
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final _backgroundImage = settingsProvider.backgroundImage;
    DecorationImage? backgroundImage;

    if (_backgroundImage != null) {
      final backgroundImageFile = File(_backgroundImage);
      if (backgroundImageFile.existsSync()) {
        backgroundImage = DecorationImage(
          image: FileImage(backgroundImageFile),
          fit: BoxFit.fitWidth,
        );
      } else {
        print('Background image file does not exist: $_backgroundImage');
      }
    } else {
      print('No background image path available.');
    }

    return HiddenDrawerMenu(
      backgroundColorAppBar: settingsProvider.isDarkMode
          ? MyThemes.lightTheme.splashColor
          : MyThemes.darkTheme.splashColor,
      elevationAppBar: 20.0,
      slidePercent: 70.0,
      verticalScalePercent: 90.0,
      isTitleCentered: true,
      contentCornerRadius: 50,
      enableScaleAnimation: true,
      typeOpen: TypeOpen.FROM_LEFT,
      backgroundColorMenu: settingsProvider.isDarkMode
          ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
          : MyThemes.darkTheme.splashColor.withOpacity(0.8),
      screens: _pages,
      backgroundMenu: _backgroundImage != null
          ? DecorationImage(
              image: FileImage(File(_backgroundImage)),
              fit: BoxFit.fitWidth,
            )
          : null,
      initPositionSelected: 0,
      boxShadow: [
        BoxShadow(
            color: Color.fromARGB(5, 1, 14, 126),
            offset: Offset.fromDirection(double.maxFinite),
            blurStyle: BlurStyle.normal)
      ],
    );
  }
}
