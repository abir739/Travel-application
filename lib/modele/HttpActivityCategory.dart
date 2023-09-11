import 'dart:convert';

import 'package:http/http.dart' as http;




import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constent.dart';
import '../modele/activitsmodel/activitiesCategoryModel.dart';



class HTTPHandlerActivityCategory {
  final storage = const FlutterSecureStorage();

  // String baseurl = "https://jsonplaceholder.typicode.com/photos";
  // String baseurl = "https://api.zenify-trip.continuousnet.com/api/plannings";
  // String baseurl = "http://192.168.1.23:3000/api/plannings";
// String baseurl = "http://192.168.1.86:3000/api/";
  // String? token = "";
  Future<List<ActivitiesCategoryModel>> fetchData(String url) async {
    // token = await storage.read(key: "access_token");
    String? token = await storage.read(key: "access_token");

// String? baseUrl = await storage.read(key: "baseurl");
//     String formater(String url) {
//       return baseUrl + url;
//     }

//     url = formater(url);
//     String baseUrl = await getBaseUrl();
//     String formater(String url) {
//       if (baseUrl.isEmpty) {
//         return baseUrls + url;
// //  "https://api.zenify-trip.continuousnet.com/api/tourist-guides";
//         // baseUrls + url;
//       } else {
//         return "${baseUrl}/api/activity-categories"; // Use the baseUrls from constants.dart
//       }
//     }
    // String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    // List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    // url = formater(baseUrl, url);
    // List<Agency> agancy = [];
    // url = formater(url);
    final respond = await http.get(headers: {
      "Authorization":
          "Bearer $token",   "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    }, Uri.parse(url));
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var data = jsonDecode(respond.body);
      // print(data);
      // final touristGuideName = data["results"]["agency"];
      // print(touristGuideName);
      final data = json.decode(respond.body);

      final List r = data["results"];
      // var r = json.decode(res.body);
      // final data = r["results"];
      print("---------------------------------baseurlbaseurlbaseurlbaseurl-------------");
      print(r[0]["id"]);
      print("--------------------------------------baseurlbaseurlbaseurlbaseurl--------");

      
      return r.map((e) => ActivitiesCategoryModel.fromJson(e)).toList();
// r.map((e) => PlanningMainModel.fromJson({"results": e})).toList();
      // return activityList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode}');
    }
  }

}
