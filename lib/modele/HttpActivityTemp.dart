import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constent.dart';
import 'activitsmodel/activityTempModel.dart';
import 'agance.dart';
 // Import the constants.dart file

class HTTPHandleractivitytemp {
  final storage = const FlutterSecureStorage();
  String? token = "";

  // Function to format the URL based on the baseUrl and url.
  // String formatUrl(String endpoint) {
  //   return baseUrls + endpoint;
  // }

  Future<List<ActivityTemplate>> fetchData(String url) async {
//     token = await storage.read(key: "access_token");
//     // String? baseUrl = await getBaseUrl(); // Call the getBaseUrl function
//     String baseUrl = await getBaseUrl();
//     String formater(String url) {
//       if (baseUrl.isEmpty) {
//         return baseUrls + url;
// //  "https://api.zenify-trip.continuousnet.com/api/tourist-guides";
//         // baseUrls + url;
//       } else {
//         return "${baseUrl}/api/activity-templates"; // Use the baseUrls from constants.dart
//       }
//     }

//     // Use baseUrls from constants.dart
    // url = formatUrl(url);
    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    // List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    });

    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final List r = data["results"];
      print("----------------------------------------------");
      print(r[0]["id"]);
      print("----------------------------------------------");
      return r.map((e) => ActivityTemplate.fromJson(e)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode}');
    }
  }
}
