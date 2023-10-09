import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/touristGroup.dart';

import '../../services/constent.dart';

class HTTPHandlerhttpGroup {
  Timer? timer;
  // String baseurl = "https://jsonplaceholder.typicode.com/photos";
  String baseurlA = "http://192.168.1.23:3000/api/";
// "https://api.zenify-trip.continuousnet.com/api/";
  String baseurlp = "https://api.zenify-trip.continuousnet.com/api/plannings";
  final storage = const FlutterSecureStorage();
  Future<List<TouristGroup>> fetchData(String url) async {
    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(Uri.parse(url), headers:  {
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
    
      return r.map((e) => TouristGroup.fromJson(e)).toList();
// r.map((e) => PlanningMainModel.fromJson({"results": e})).toList();
      // return activityList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode}');
    }
  }

  String formater(String url) {
    return baseurlA + url;
  }
}
