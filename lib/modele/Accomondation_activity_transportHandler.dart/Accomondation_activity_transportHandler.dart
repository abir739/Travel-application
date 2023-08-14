import 'dart:convert';
import 'package:http/http.dart' as http;

import '../accommodationsModel/accommodationModel.dart';
import '../activitsmodel/activitesmodel.dart';
import '../transportmodel/transportModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class HTTPHandlerTravellerPlanning {
  // String baseUrl = "https://jsonplaceholder.typicode.com/photos";
final storage = const FlutterSecureStorage();
  Future<List<Activity>> fetchActivities(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formater(String url) {
      if (baseUrl != null) {
        return baseUrl + url;
      } else {
        return 'http://192.168.1.14:3000/api/agencies';
      }
    }

    url = formater(url);

    List<Activity> activityList = [];
 
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['activities'];
      activityList = resultList.map((e) => Activity.fromJson(e)).toList();
      return activityList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<List<Accommodations>> fetchAccommodations(String url) async {
    List<Accommodations> accommodationList = [];
      String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formater(String url) {
      if (baseUrl != null) {
        return baseUrl + url;
      } else {
        return 'http://192.168.1.14:3000/api/agencies';
      }
    }

    url = formater(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['accommodations'];
      accommodationList =
          resultList.map((e) => Accommodations.fromJson(e)).toList();
      return accommodationList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<List<Transport>> fetchTransfers(String url) async {
    List<Transport> transferList = [];
     String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formater(String url) {
      if (baseUrl != null) {
        return baseUrl + url;
      } else {
        return 'http://192.168.1.14:3000/api/agencies';
      }
    }

    url = formater(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['transfers'];
      transferList = resultList.map((e) => Transport.fromJson(e)).toList();
      return transferList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }


}
