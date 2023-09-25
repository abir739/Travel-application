import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Secreens/Notification/NotificationCountNotifierProvider.dart';

class OneSignalHandler {
  static void initialize(BuildContext context) {
    // OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    //   print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    // });
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult notification) {
        print("${notification.notification.body} actions");
        print("Notification Opened: ${notification.notification.body}");
        final notificationCountNotifier =
            Provider.of<NotificationCountNotifier>(context, listen: false);

        // Increment the notification count
        notificationCountNotifier.increment();
        _handlePromptForPushPermission;
        Map<String, dynamic>? additionalData =
            notification.notification.additionalData;
        print("${additionalData} additionalData");

        // Navigate to the desired screen based on payload data
        if (additionalData!.containsKey('screen')) {
          String screenName = additionalData['screen'];
          String ObjectType = additionalData['ObjectType'];
          String id = additionalData['id'];
          String idt = additionalData['idT'];
          print("$screenName      print(screenName);");
          print("$ObjectType      print(ObjectType);");
          print("$id      print(id);");
          print("$idt      print(id);");
          _checkTokenAndNavigate(context, screenName, id, ObjectType,idt);
          // final notificationCountNotifier =
          //     Provider.of<NotificationCountNotifier>(context, listen: false);

          // // Increment the notification count
          // notificationCountNotifier.increment();
        }
      },
    );
  
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
        final notificationCountNotifier =
            Provider.of<NotificationCountNotifier>(context, listen: false);

        notificationCountNotifier.increment();
      },
    );
 }

  static Future<void> processBackgroundNotifications() async {
    // Handle background notifications here
    // For example, increment a notification count
    // You can also perform other background tasks related to notifications

    print("Processing background notifications...");

    // Your custom logic here
  }
  // static Future<void> incrementNotificationCountInBackground() async {
  //   // Retrieve the current notification count from persistent storage
  //   final prefs = await SharedPreferences.getInstance();
  //   int notificationCount = prefs.getInt('notificationCount') ?? 0;

  //   // Increment the count
  //   notificationCount++;

  //   // Save the updated count back to persistent storage
  //   await prefs.setInt('notificationCount', notificationCount);

  //   print("Notification count incremented to: $notificationCount");
  // }

  static void _checkTokenAndNavigate(BuildContext context, String screenName,
      String? id, String? ObjectType,String? idt,) async {
    final token = await _getToken();
    if (screenName == 'notification' && token == null) {
      // final notificationCountNotifier =
      //     Provider.of<NotificationCountNotifier>(context, listen: false);

      // // Increment the notification count
      // notificationCountNotifier.increment();
      // If the user doesn't have a token and is navigating to "Traveller", do something
      // For example, show an alert or navigate to a different screen
      print('User does not have a token. Handle this case.');
      Get.toNamed('login')!.then((_) {
        Get.offNamed('notification', arguments: {
          'id': id,
          'routename': screenName,
          'ObjectType': ObjectType,
          'idT': idt
        });
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
      // final notificationCountNotifier =
      //     Provider.of<NotificationCountNotifier>(context, listen: false);

      // // Increment the notification count
      // notificationCountNotifier.increment();
// Navigator.pushNamed(
//         context,
//         'notification',
//         arguments: {'
//           'id': id
//         }, // Replace 'your_id_here' with the actual ID
//       );
      // User has a token or is navigating to a different screen, proceed with navigation
      Get.toNamed('notification', arguments: {
        'id': id,
        'routename': screenName,
        'ObjectType': ObjectType  ,'idT': idt
      });
    } else {
      Get.toNamed(screenName);
    }
  }

 static void _handlePromptForPushPermission() {
    print("Prompting for Permission");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  static Future<String?> _getToken() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }
}
