import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zenify_trip/services/constent.dart';
// import 'package:zenify_trip_mobile/modele/activity_model.dart';

import '../modele/planning_model.dart';
import '../modele/planningmainModel.dart';
import '../modele/plannings.dart';


import 'activitsmodel/usersmodel.dart';
import 'listPlannig.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpUserHandler {
  final storage = const FlutterSecureStorage();

  // String baseurl = "https://jsonplaceholder.typicode.com/photos";
  // String baseurl = "https://api.zenify-trip.continuousnet.com/api/plannings";
  // String baseurl = "http://192.168.1.23:3000/api/plannings";
// String baseurl = "http://192.168.1.23:3000/api/";
  String? token = "";
 Future<User> fetchUser(String url) async {
    // String? baseUrl = await storage.read(key: "baseurl");
    String? token = await storage.read(key: "access_token");
  // String baseUrl = await getBaseUrl();
    String formater(String url) {
      // if (baseUrl.isEmpty) {
        return baseUrls + url;
//  "https://api.zenify-trip.continuousnet.com/api/tourist-guides";
        // baseUrls + url;
      // } else {
      //   return "${baseUrl}/api/users"; // Use the baseUrls from constants.dart
      // }
    }

    // String formattedUrl(String url) {
    //   if (baseUrl != null) {
    //     return baseUrl + url;
    //   } else {
    //     return 'http://192.168.1.14:3000/api/user';
    //   }
    // }

    //  String url = formattedUrl("/api/users/$userId");
url = formater(url);
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token",   "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",},
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }
//   Future<DateTime> fetchtime(String url) async {
//     List<PlanningMainModel> planingList = [];
//     url = formater(url);
// String? token = await storage.read(key: "access_token");
//     final respond = await http.get(headers: {
//       "Authorization":
//           "$token"
//     }, Uri.parse(url));
//     print(respond.statusCode);
//     if (respond.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       // var data = jsonDecode(respond.body);
//       // print(data);
//       // final touristGuideName = data["results"]["agency"];
//       // print(touristGuideName);
//       final data = json.decode(respond.body);

//       final List r = data["results"];
//       // var r = json.decode(res.body);
//       // final data = r["results"];
//       print("----------------------------------------------");
//       print(r[0]["startDate"]);
//       print("----------------------------------------------");

//       // for (Map<String, dynamic> d in data) {
//       //   Activity activity = Activity.fromJSON(d);
//       //   activityList.add(activity);
//       // }
//       // return result;
//       return r[0]["startDate"];
// // r.map((e) => PlanningMainModel.fromJson({"results": e})).toList();
//       // return activityList;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('${respond.statusCode}');
//     }
//   }

  // String formater(String baseurl, String url) {
  //   return baseurl + url;
  // }
}
