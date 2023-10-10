import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrls = "http://192.168.1.92:3000";
//const String baseUrls = "https://api.zenify-trip.continuousnet.com";

// final String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';
// const String baseUrls = "http://192.168.152.53:3000";
// final accountSid = 'ACc47bfeda04bc38275dded333a92666bc';
// final authToken = '70b4d4ec6bec695f4c0dfd9205a9e5b1';
// final twilioNumber = '+12564154864';
Future<String?> getBaseUrl() async {
  final storage = const FlutterSecureStorage();
  return await storage.read(key: "baseurl");
}

DateTime formatDateTimeInTimeZone(DateTime utcDateTime) {
  final localDateTime = utcDateTime.toLocal();
  return localDateTime;
}

String thumbsUpEmoji = '\u{1F44D}';
String thumbsDownEmoji = '\u{1F44E}';
String laughingEmoji = '\u{1F604}';
String cryingEmoji = '\u{1F622}';
String fireEmoji = '\u{1F525}';
String settingsEmoji = '\u2699';
String calendarEmoji = '\u{1F4C6}';
String partyEmoji = '\u{1F389}';
String birthdayEmoji = '\u{1F382}';
String starEyesEmoji = '\u{1F929}';
String crownEmoji = '\u{1F451}';
String moneyBagEmoji = '\u{1F4B0}';
String rainbowEmoji = '\u{1F308}';
String airplaneEmoji = '\u{2708}\u{FE0F}';
String cameraEmoji = '\u{1F4F7}';
String bookEmoji = '\u{1F4D6}';
String pizzaEmoji = '\u{1F355}';
String coffeeEmoji = '\u{2615}';
String dogEmoji = '\u{1F436}';
String catEmoji = '\u{1F431}';
String sunEmoji = '\u{2600}\u{FE0F}';
String moonEmoji = '\u{1F319}';
String bicycleEmoji = '\u{1F6B2}';
String carEmoji = '\u{1F697}';
String heartEmoji = '\u{2764}\u{FE0F}';
String smileyFaceEmoji = '\u{1F60A}';
String starEmoji = '\u{2B50}';
String checkmarkEmoji = '\u{2705}';
String heartEyesEmoji = '\u{1F60D}';
String faceWithTearsOfJoyEmoji = '\u{1F602}';
String thinkingFaceEmoji = '\u{1F914}';
String thumbsUpMediumSkinToneEmoji = '\u{1F44D}\u{1F3FD}';
String rocketShipEmoji = '\u{1F680}';
String sushiEmoji = '\u{1F363}';
String soccerBallEmoji = '\u{26BD}';
String pandaFaceEmoji = '\u{1F43C}';
String catFaceWithHeartEyesEmoji = '\u{1F63B}';
String hatchingChickEmoji = '\u{1F423}';
String logoutEmoji = '🚪';
String groupsEmoji = '👫';
String transportEmoji = '🚗';
String tasksEmoji = '📋';
String addNotificationEmoji = '🔔';
String informationsEmoji = 'ℹ️';






