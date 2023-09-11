import 'dart:convert';


import 'package:http/http.dart' as http;




import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'activitsmodel/pushnotificationmodel.dart';

class HTTPHandlerPushNotification {
  final storage = const FlutterSecureStorage();

  // String baseurl = "https://jsonplaceholder.typicode.com/photos";
  // String baseurl = "https://api.zenify-trip.continuousnet.com/api/plannings";
  // String baseurl = "http://192.168.1.23:3000/api/plannings";
// String baseurl = "http://192.168.1.86:3000/api/";
  String? token = "";
  Future<List<PushNotification>> fetchData(String url) async {
    // token = await storage.read(key: "access_token");
    String? token = await storage.read(key: "access_token");
String? baseUrl = await storage.read(key: "baseurl");
   String formater(String url) {
      if (baseUrl != null) {
        return baseUrl + url;
      } else {
        return 'http://192.168.1.13:3000/api/push-notifications';
      }
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
       //final data = r["results"];
      // print("----------------------------------------------");
      // print(r[0]["id"]);
      // print("----------------------------------------------");

      
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
