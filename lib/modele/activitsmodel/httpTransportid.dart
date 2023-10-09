import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zenify_trip/modele/activitsmodel/activitesmodel.dart';
import 'package:zenify_trip/modele/planning_model.dart';
import 'package:zenify_trip/modele/planningmainModel.dart';
import 'package:zenify_trip/modele/plannings.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../../services/constent.dart';
import 'activityTempModel.dart';


class HTTPHandlerTrasportId {

  final storage = const FlutterSecureStorage();
  Future<Transport> fetchData(String url) async {
    String? baseUrl = await storage.read(key: "baseurl");
    String? token = await storage.read( key: 'access_token');
   
    // String formater(String baseurl, String url) {
    //   print(baseurl + url);
    //   print(" urllllllllllllllllllllllllllll");
    //   return baseurl + url;
    // }

    // url = formater(baseUrl, url);
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(headers: {
      "Authorization":
          "Bearer $token"    }, Uri.parse(url));
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var data = jsonDecode(respond.body);
      // print(data);
      // final touristGuideName = data["results"]["agency"];
      // print(touristGuideName);
  

   
      final data = json.decode(respond.body);
    return Transport.fromJson(data);
  

    } else {
    
      throw Exception('${respond.statusCode}');

    }
  }

  // String formater(String url) {
  //   return baseurlA + url;
  // }
}
