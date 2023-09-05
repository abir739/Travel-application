// import 'package:flutter/material.dart';
// import 'package:zenify_trip/register.dart';
// import 'package:get/get.dart';

// import 'login.dart';
// import 'login/RoleSelectionPage.dart';

// void main() {
//   runApp(GetMaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: RoleSelectionPage(),
//     routes: {
//       'register': (context) => const MyRegister(),
//       'login': (context) => const RoleSelectionPage(),
//     },
//   ));
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:zenify_trip/Secreens/Notification/NotificationDetails.dart';
import 'package:zenify_trip/Secreens/TouristGroupProvider.dart';
import 'package:zenify_trip/login/RoleSelectionPage.dart';
import 'package:zenify_trip/register.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';

import 'Secreens/acceuil/welcomPgeGuid.dart';
import 'constent.dart';
import 'onesignal_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignalHandler.initialize(context);
  runApp(
    ChangeNotifierProvider(
      create: (context) => TouristGroupProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OneSignalHandler.initialize(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const RoleSelectionPage(),
        // 'planning': (context) => const PlaningSecreen(), // Add this route
        'Traveller': (context) => TravellerFirstScreen(
              userList: const [],
            ), // Add this route
        'SplashScreen': (context) => SplashScreen(), // Add this route
        'GuideHome': (context) =>
            const PlaningSecreen(), // Add this routeActivityDetailScreen
        'notification': (context) {
          final args =
              Get.arguments; // Get the arguments passed when navigating
          final id = args != null
              ? args['id'] as String
              : null; // Extract the 'id' argument
          final routname = args != null
              ? args['routename'] as String
              : null; // Extract the 'id' argument
          print("ID from route: $id"); // Print the 'id'
          print(" routename: $routname"); // Print the 'id'
          return ActivityDetailScreen(id: id);
        } // Add this routeActivityDetailScreen
      },
      initialRoute: 'SplashScreen',
    );
  }

  Future<String?> _getToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }

  Future<String?> _getRole() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "Role");
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 24, 10, 221)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String initialRoute = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(initialRoute);
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: AlwaysStoppedAnimation<Color>(
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
      FlutterSecureStorage storage = const FlutterSecureStorage();
      return await storage.read(key: "access_token");
    }

    Future<String?> _getRole() async {
      FlutterSecureStorage storage = const FlutterSecureStorage();
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
    FlutterSecureStorage storage = const FlutterSecureStorage();
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
