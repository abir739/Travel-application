import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../../constent.dart';

class HTTPHandlerTransfer {
  final storage = const FlutterSecureStorage();
  Future<List<Transport>> fetchData(String url) async {
    // String? baseUrl = await storage.read(key: "baseurl");
    // String token = await storage.read( key: 'access_token');
    List<Transport> activites = [];
    // String formater(String baseurl, String url) {
    //   print(baseurl + url);
    //   print(" urllllllllllllllllllllllllllll");
    //   return baseurl + url;
    // }

    // url = formater(baseUrl, url);
    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    // List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
    }, Uri.parse(url));
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);

      final List r = data["results"];

      print(r);
      print("--------------------------------------------fffff--");
      print(r[0]["touristGuideId"]);
      print("-------------------------------------departureDate---------");
      print("----------------------------------------------");
      print(r[0]["departureDate"]);
      print("--------------------------------------departureDate--------");

      return r.map((e) => Transport.fromJson(e)).toList();
    } else {
      throw Exception('${respond.statusCode}');
    }
  }

  // String formater(String url) {
  //   return baseurlA + url;
  // }
}

class HTTPHandlerCount {
  final storage = const FlutterSecureStorage();

  Future<int> fetchInlineCount(String url) async {
    String? token = await storage.read(key: "access_token");
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
// await storage.read(key: "baseurl");
    String formater(String url) {
      // if (baseUrl != null) {
      return baseUrls + url;
      // } else {
      //   return 'https://api.zenify-trip.continuousnet.com';
      // }
    }

    url = formater(url);

    // url = formater(baseUrl, url);
    // List<Agency> agancy = [];
    // url = formater(url);
    final respond = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));
    print(respond.statusCode);

    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final int inlineCount = data["inlineCount"];
      return inlineCount;
    } else {
      throw Exception(
          'Failed to fetch inline count. Status code: ${respond.statusCode}');
    }
  }
}
