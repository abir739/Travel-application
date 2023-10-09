import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import 'activitsmodel/pushnotificationmodel.dart';

// class HTTPHandlerNotificationId {

//   final storage = const FlutterSecureStorage();
//   Future<PushNotification> fetchData(String url) async {
//     String? baseUrl = await storage.read(key: "baseurl");
//     String? token = await storage.read( key: 'access_token');

//     // String formater(String baseurl, String url) {
//     //   print(baseurl + url);
//     //   print(" urllllllllllllllllllllllllllll");
//     //   return baseurl + url;
//     // }

//     // url = formater(baseUrl, url);
//     String formater(String url) {
//       return baseUrls + url;
//     }

//     url = formater(url);
//     final respond = await http.get(headers: {
//       "Authorization":
//           "Bearer $token"    }, Uri.parse(url));
//     print(respond.statusCode);
//     if (respond.statusCode == 200) {

//       final data = json.decode(respond.body);
//     return PushNotification.fromJson(data);

//     } else {

//       throw Exception('${respond.statusCode}');

//     }
//   }

//   // String formater(String url) {
//   //   return baseurlA + url;
//   // }
// }
class HTTPHandlerNotificationId {
  final storage = const FlutterSecureStorage();

  Future<PushNotification> fetchData(String url) async {
    try {
      // final baseUrl = await storage.read(key: "baseurl");
      final token = await storage.read(key: 'access_token');

      // Create a formatted URL using the base URL and provided endpoint
      final formattedUrl = '$baseUrls$url'.replaceAll(' ', '');
      print(formattedUrl);
      final response = await http.get(
        Uri.parse(formattedUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print(response.body);
        // print("dataaaaaaaaaaaa $data");
        return PushNotification.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here, e.g., network errors
      throw Exception('Failed to fetch data. Error: $e');
    }
  }
}
