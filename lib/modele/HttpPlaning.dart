import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constent.dart';
import '../modele/planningmainModel.dart';
 // Import the constants.dart file

class HTTPHandlerplaning {
  final storage = const FlutterSecureStorage();

  Future<List<PlanningMainModel>> fetchData(String url) async {
    // String baseUrl = await storage.read(key: "baseurl");
    // String? token = await storage.read(key: "access_token");
    // List<PlanningMainModel> planningList = [];

    // String formater(String url) {
    //   if (baseUrls != null) {
    //     return baseUrls + url;
    //   } else {
    //     return baseUrls + "/api/plannings";
    //   }
    // }

    // url = formater(url);
//     String baseUrl = await getBaseUrl();
//     String formater(String url) {
//       if (baseUrl.isEmpty) {
//         return baseUrls + url;
// //  "https://api.zenify-trip.continuousnet.com/api/tourist-guides";
//         // baseUrls + url;
//       } else {
//         return "${baseUrl} + $url"; // Use the baseUrls from constants.dart
//       }
//     }

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
      return r.map((e) => PlanningMainModel.fromJson(e)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode}');
    }
  }
}
