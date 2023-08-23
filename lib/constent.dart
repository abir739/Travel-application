import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrls = "https://api.zenify-trip.continuousnet.com";
// const String baseUrls = "http://192.168.140.53:3000";

Future<String?> getBaseUrl() async {
  final storage = const FlutterSecureStorage();
  return await storage.read(key: "baseurl");
}
