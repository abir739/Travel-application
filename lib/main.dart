import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:zenify_trip/Secreens/Upload_Files/FileUploadScreen.dart';
import 'package:zenify_trip/login/RoleSelectionPage.dart';
import 'package:zenify_trip/register.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:zenify_trip/traveller_Screens/Traveller-First-Screen.dart';
import 'package:zenify_trip/traveller_Screens/Traveller-Provider.dart';
import 'Controller/dependency_injection.dart';
import 'ResetPasswordWithPhoneNumberScreen.dart';
import 'Secreens/Notification/NotificationCountNotifierProvider.dart';
import 'Secreens/Notification/notificationlist.dart';
import 'Secreens/Notifications/NotificationDetails.dart';
import 'Secreens/TouristGroupProvider.dart';
import 'guide_Screens/Guide_First_Page.dart';
import 'constent.dart';
import 'onesignal_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignalHandler.initialize(context);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationCountNotifier()),
        ChangeNotifierProvider(create: (_) => TouristGroupProvider()),
          ChangeNotifierProvider(
      create: (context) => TravellerProvider()),
        // Add more providers as needed
      ],
      child: MyApp(),
    ),
  );
  DependencyInjection.init();
  tzdata.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OneSignalHandler.initialize(context);
    OneSignalHandler.listenToIncomingSMS(context, OneSignalHandler.telephony);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'register': (context) => MyRegister(),
        'resetPassword': (context) => ResetPasswordWithPhoneNumberScreen(),
        'login': (context) => const RoleSelectionPage(),
        'notificationScreen': (context) => NotificationScreen(
              groupsid: '',
            ),
        'planning': (context) => PlaningSecreen(), // Add this route
        'Traveller': (context) => TravellerFirstScreen(
              userList: [],
            ),
        // Add this route
        'SplashScreen': (context) => SplashScreen(), // Add this route
         'FileUploadScreen': (context) => FileUploadScreen(
            dynamicPath: "", fild: "", object: "", id: ""),

        'GuideHome': (context) =>
            PlaningSecreen(), // Add this routeActivityDetailScreen
        'notification': (context) {
          final args =
              Get.arguments; // Get the arguments passed when navigating
          final id = args != null
              ? args['id'] as String
              : null; // Extract the 'id' argument
          final routname = args != null
              ? args['routename'] as String
              : null; // Extract the 'id' argument
          final ObjectType = args != null
              ? args['ObjectType'] as String
              : null; // Extract the 'id' argument
          return ActivityDetailScreen(
            id: id,
            ObjectType: ObjectType,
          );
        } // Add this routeActivityDetailScreen
      },
      initialRoute: 'SplashScreen',
    );
  }

  Future<String?> _getToken() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }

  Future<String?> _getRole() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "Role");
  }

//   Future<String?> _getInitialRoute() async {
//     // Use the appropriate method to access the storage
//     String? token = await _getToken();
//     String? role = await _getRole();

//     if (token != null && role == "Administrator") {
//       return 'planning';
//     } else if (token != null && role != "Administrator") {
//       return 'Traveller';
//     } else {
//       return 'login';
//     }
//   }
}
// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _getInitialRoute(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           String initialRoute = snapshot.data!;
//           WidgetsBinding.instance!.addPostFrameCallback((_) {
//             Navigator.of(context).pushReplacementNamed(initialRoute);
//           });
//           return Scaffold(); // Return an empty Scaffold while navigating
//         }
//       },
//     );
//   }

//   Future<String> _getInitialRoute() async {
//     String? token = await _getToken();
//     String? role = await _getRole();

//     if (token != null && role == "Administrator") {
//       return 'planning';
//     } else if (token != null && role != "Administrator") {
//       return 'Traveller';
//     } else {
//       return 'login';
//     }
//   }
// }

// Future<String?> _getToken() async {
//   FlutterSecureStorage storage = FlutterSecureStorage();
//   return await storage.read(key: "access_token");
// }

// Future<String?> _getRole() async {
//   FlutterSecureStorage storage = FlutterSecureStorage();
//   return await storage.read(key: "Role");
// }
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 24, 10, 221)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String initialRoute = snapshot.data!;
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(initialRoute);
          });
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 24, 10, 221)),
              ),
            ),
          ); // Return an empty Scaffold while navigating
        }
      },
    );
  }

  Future<String> _getInitialRoute() async {
    Future<String?> _getToken() async {
      FlutterSecureStorage storage = FlutterSecureStorage();
      return await storage.read(key: "access_token");
    }

    Future<String?> _getRole() async {
      FlutterSecureStorage storage = FlutterSecureStorage();
      return await storage.read(key: "Role");
    }

    final bool tokenIsValid =
        await _validateToken(); // Replace with your validation logic
    String? role = await _getRole();
    print("$role Role");
    if ((tokenIsValid && (role == "Administrator" || role == "TouristGuide"))) {
      return 'planning';
    } else if (tokenIsValid && role != "Traveller") {
      return 'Traveller';
    } else {
      return 'register';
    }
  }

  Future<bool> _validateToken() async {
    // Replace this with your token validation logic
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: "access_token");

    // Call your API to refresh the token
    String? refreshedToken = await _refreshToken(token);

    if (refreshedToken != null) {
      // Update the stored token
      await storage.write(key: "access_token", value: refreshedToken);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _refreshToken(String? token) async {
    final refreshTokenUrl = Uri.parse('${baseUrls}/api/auth/refresh-token');
    print("$token token");
    try {
      // Create the request headers and payload
      final headers = {'Content-Type': 'application/json'};
      final payload = jsonEncode({'refreshToken': token});

      // Make the HTTP POST request to refresh the token
      final response =
          await http.post(refreshTokenUrl, headers: headers, body: payload);

      // Check the response status
      if (response.statusCode == 201) {
        // Token refresh successful, extract the new token from the response
        final responseBody = jsonDecode(response.body);

        final newToken = responseBody['accessToken'] as String;
        print("$newToken newToken");
        return newToken;
      } else {
        // Token refresh failed, return null
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the request
      print('Error refreshing token: $error');
      return null;
    }
  }
}
