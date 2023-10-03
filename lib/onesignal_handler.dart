import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';
import 'package:twilio/twilio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'Secreens/Notification/NotificationCountNotifierProvider.dart';
import 'package:telephony/telephony.dart';
import 'constent.dart';

Twilio twilio = Twilio(
    accountSid: accountSid, authToken: authToken, twilioNumber: twilioNumber);

class OneSignalHandler {
  static Telephony telephony = Telephony.instance;
  static void initialize(BuildContext context) {
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
          _checkTokenAndNavigate(context, screenName, id, ObjectType, idt);
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

  static void _checkTokenAndNavigate(
    BuildContext context,
    String screenName,
    String? id,
    String? ObjectType,
    String? idt,
  ) async {
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
        'ObjectType': ObjectType,
        'idT': idt
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
static Future<String?> listenToIncomingSMS(
      BuildContext context, Telephony telephony) {
    Completer<String?> validationCodeCompleter = Completer<String?>();

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // Extract the validation code from the received SMS
        final validationCode = extractValidationCodeFromSMS(message.body);

        if (validationCode != null) {
          // Resolve the Future with the validation code
          validationCodeCompleter.complete(validationCode);
          print(validationCode); // Print the validation code here
          handleIncomingValidationCode(context, validationCode);
        }
      },
      listenInBackground: false,
    );

    return validationCodeCompleter.future;
  }

  // static Future<String?> listenToIncomingSMS(
  //     BuildContext context, Telephony telephony) async {
  //   Completer<String?> validationCodeCompleter = Completer<String?>();

  //   telephony.listenIncomingSms(
  //     onNewMessage: (SmsMessage message) {
  //       // Extract the validation code from the received SMS
  //       final validationCode = extractValidationCodeFromSMS(message.body);
  //  storage.write(key: "code", value: validationCode);
  //       if (validationCode != null) {
  //         // Resolve the Future with the validation code
  //         // validationCodeCompleter.complete(validationCode);
  //          storage.write(key: "code", value: validationCode);
  //         print(validationCodeCompleter.future);
  //         // handleIncomingValidationCode(context, validationCode);
  //       }
  //     },
  //     listenInBackground: false,
  //   );

  //   return validationCodeCompleter.future;
  // }

  static String handleIncomingValidationCode(
      BuildContext context, String code) {
    // Your code to handle the incoming validation code
    print("$code codeeee");
    return code;
  }

  static String? extractValidationCodeFromSMS(String? messageBody) {
    // Define a regular expression pattern to match a 6-digit code
    final RegExp regex = RegExp(r'\b\d{6}\b');

    // Search for the code pattern in the message body
    final Match? match = regex.firstMatch(messageBody ?? "hh");

    // If a match is found, extract and return the code
    if (match != null) {
      return match.group(0);
    } else {
      // If no match is found, return null or handle it as needed
      return null;
    }
  }
}
