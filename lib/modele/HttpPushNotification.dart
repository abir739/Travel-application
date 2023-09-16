import 'dart:convert';


import 'package:http/http.dart' as http;




import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constent.dart';
import 'activitsmodel/pushnotificationmodel.dart';
import 'agance.dart';

class HTTPHandlerPushNotification {
  final storage = const FlutterSecureStorage();
  String? token = "";
  Future<List<PushNotification>> fetchData(String url) async {

    List<PushNotification> activites = [];

    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";

    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond =  await http.get(Uri.parse(url), headers:  {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
    });
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final List r = data["results"];
    final  notifications=   r.map((e) => PushNotification.fromJson(e)).toList();
return Future.value(notifications);
// r.map((e) => PlanningMainModel.fromJson({"results": e})).toList();
      // return activityList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('${respond.statusCode}');
    }
  }

}
