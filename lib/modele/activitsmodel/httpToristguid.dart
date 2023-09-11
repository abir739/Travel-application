import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zenify_trip/modele/TouristGuide.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../../constent.dart';

class HTTPHandlerhttpToristguid {
  Timer? timer;
  final storage = const FlutterSecureStorage();

  Future<List<TouristGuide>> fetchData(String url) async {
    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    // List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
//     String token = await storage.read(key: 'access_token');
//     String baseUrl =
//         await getBaseUrl(); // Call the getBaseUrl function from constants.dart
    List<TouristGuide> touristGuide = [];

//     String formater(String url) {
//       if (baseUrl.isEmpty ) {
//         return baseUrls + url;
// //  "https://api.zenify-trip.continuousnet.com/api/tourist-guides";
//         // baseUrls + url;
//       } else {
//         return "${baseUrl}/api/tourist-guides"; // Use the baseUrls from constants.dart
//       }
//     }

//     url = formater(url);
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
      print(r);
      print("--------------------------------------------fffff--");
      print(r[0]["name"]);
      print("-------------------------------------name---------");
      print("----------------------------------------------");
      print(r[0]["nationalityCountry"]);
      print("--------------------------------------nationalityCountry--------");

      return r.map((e) => TouristGuide.fromJson(e)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode} HTTPHandlerhttpGroup.fetchData');
    }
  }
}
// class HTTPHandlerhttpToristguid {
//   Timer? timer;
//   // String baseurl = "https://jsonplaceholder.typicode.com/photos";
//   String baseurlA = "http://192.168.1.86:3000/api/";
// // "https://api.zenify-trip.continuousnet.com/api/";
//   String baseurlp = "https://api.zenify-trip.continuousnet.com/api/plannings";
//   final storage = const FlutterSecureStorage();
//   Future<List<TouristGuide>> fetchData(String url) async {
//     String token = await storage.read(key: 'access_token');
//     String? baseUrl = "https://api.zenify-trip.continuousnet.com";
//     // await storage.read(key: "baseurl");
//     List<TouristGuide> touristGuide = [];
//     String formater(String url) {
//       return baseUrl + url;
//     }

//     url = formater(url);
//     final respond = await http.get(headers: {
//       "Authorization": "Bearer $token",
//       "Accept": "application/json, text/plain, */*",
//       "Accept-Encoding": "gzip, deflate, br",
//       "Accept-Language": "en-US,en;q=0.9",
//       "Connection": "keep-alive",
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
//       print(r);
//       print("--------------------------------------------fffff--");
//       print(r[0]["name"]);
//       print("-------------------------------------name---------");
//       print("----------------------------------------------");
//       print(r[0]["nationalityCountry"]);
//       print("--------------------------------------nationalityCountry--------");

//       // for (Map<String, dynamic> d in data) {
//       //   Activity activity = Activity.fromJSON(d);
//       //   activityList.add(activity);
//       // }
//       // return result;
//       return r.map((e) => TouristGuide.fromJson(e)).toList();
// // r.map((e) => PlanningMainModel.fromJson({"results": e})).toList();
//       // return activityList;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('${respond.statusCode} HTTPHandlerhttpGroup.fetchData');
//     }
//   }
// }
