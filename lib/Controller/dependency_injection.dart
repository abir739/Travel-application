import 'package:get/get.dart';

import 'network_controller.dart';

import 'package:telephony/telephony.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }

  // static void listenToIncomingSMSs() {
  //   print("Listening to incoming SMS messages...");
  //   Telephony telephony = Telephony.instance;

  //   telephony.listenIncomingSms(
  //     onNewMessage: (SmsMessage message) {
  //       print(message);
  //       // Extract the validation code from the received SMS
  //       final validationCode = extractValidationCodeFromSMS(message.body);
  //       print("Listening to incoming SMS messages...");
  //       if (validationCode != null) {
  //         print(validationCode);
  //         // Trigger the function to handle the validation code
  //         // handleIncomingValidationCode(context, validationCode);
  //         print("Listening to incoming SMS messages...");
  //         print("Listening to incoming SMS messages...");
  //         print("Listening to incoming SMS messages...");
  //         print("Listening to incoming SMS messages...");
  //       }
  //     },
  //     listenInBackground: false,
  //   );
  // }

  // static void handleIncomingValidationCode(BuildContext context, String code) {
  //   // Your code to handle the incoming validation code
  //   print("$code codeeee");
  // }

  // static String? extractValidationCodeFromSMS(String? messageBody) {
  //   // Define a regular expression pattern to match a 6-digit code
  //   final RegExp regex = RegExp(r'\b\d{6}\b');

  //   // Search for the code pattern in the message body
  //   final Match? match = regex.firstMatch(messageBody ?? "hh");

  //   // If a match is found, extract and return the code
  //   if (match != null) {
  //     return match.group(0);
  //   } else {
  //     // If no match is found, return null or handle it as needed
  //     return null;
  //   }
  // }
}
