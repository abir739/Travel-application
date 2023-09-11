import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OneSignalHandler {
  static void initialize(BuildContext context) {
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult notification) {
        print("${notification.notification.body} actions");
        print("Notification Opened: ${notification.notification.body}");

        // Extract data from the notification payload
        Map<String, dynamic>? additionalData =
            notification.notification.additionalData;
        print("$additionalData additionalData");

        // Navigate to the desired screen based on payload data
        if (additionalData!.containsKey('screen')) {
          String screenName = additionalData['screen'];
          String id = additionalData['id'];
          print("$screenName      print(screenName);");
          print("$id      print(id);");
          _checkTokenAndNavigate(context, screenName, id);
        }
      },
    );
  }

  static void _checkTokenAndNavigate(
      BuildContext context, String screenName, String? id) async {
    final token = await _getToken();
    if (screenName == 'notification' && token == null) {
      // If the user doesn't have a token and is navigating to "Traveller", do something
      // For example, show an alert or navigate to a different screen
      print('User does not have a token. Handle this case.');
      Get.toNamed('login')!.then((_) {
        Get.offNamed('notification',
            arguments: {'id': id, 'routename': '_checkTokenAndNavigate'});
        // After the user logs in, navigate back to the original screen
        // Get.offNamed('notification');
// Navigator.pushNamed(
//           context,
//           'notification',
//           arguments: {
//             'id': id
//           }, // Replace 'your_id_here' with the actual ID
//         );
      });
    } else if (screenName == 'notification' && token != null) {
// Navigator.pushNamed(
//         context,
//         'notification',
//         arguments: {
//           'id': id
//         }, // Replace 'your_id_here' with the actual ID
//       );
      // User has a token or is navigating to a different screen, proceed with navigation
      Get.offNamed('notification',
          arguments: {'id': id, 'routename': '_checkTokenAndNavigate'});
    } else {
      Get.toNamed(screenName);
    }
  }

  static Future<String?> _getToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }
}
