import 'package:flutter/material.dart';
import 'package:zenify_trip/Secreens/Notification/NotificationDetails_test.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';

// import '../Secreens/Notifications/NotificationDetails.dart';

import '../login.dart';
import '../main.dart';

class AppRoutes {
  static const String ROUTE_Initial = ROUTE_Splashscreen;
  static const String ROUTE_Home = "/home";
  static const String ROUTE_Splashscreen = "/SplashScreen";
  static const String ROUTE_Traveller = "/Traveller";
  static const String ROUTE_Login = "/login";
  static const String ROUTE_PlaningSecreen = "/planning";
  static const String ROUTE_register = "/register";
  static const String ROUTE_ActivityDetailScreen = "/ActivityDetailScreen";

  static const String ROUTE_Notification = "/notification"; // Add a new route

  // Add a method to generate routes
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_Home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyLogin(),
        );
      case ROUTE_Splashscreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );
      case ROUTE_Traveller:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TravellerFirstScreen(
            userList: [],
          ),
        );
      case ROUTE_Login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MyLogin(),
        );
      case ROUTE_Notification:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>;
            final id = args['id'] as String;
            final routename = args['routename'] as String;
            final ObjectType = args['ObjectType'] as String;
            final idt = args['idT'] as String;
            return ActivityDetailScreen(
                id: id, ObjectType: ObjectType, idt: idt);
          },
        );
      default:
        // Handle unknown routes here, e.g., return a "not found" page
        return MaterialPageRoute(
          builder: (_) => MyLogin(),
        );
    }
  }
}
