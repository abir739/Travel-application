import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class NetworkHandler {
  FlutterSecureStorage storage = FlutterSecureStorage();

  static const baseurl = "http://192.168.1.65:3000";
// "https://api.zenify-trip.continuousnet.com";



  Future get(String url) async {
// String baseUrld = "http://192.168.1.23:3000";
// await storage.write(key: "baseurl", value: baseUrld);
    String? token = await storage.read(key: "access_token");
    url = formater(url);
    // /user/register
    print(token);

    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // log.i(json.decode(response.body), "the response of get");
      final List result = json.decode(response.body);
      return json.decode(response.body);

// json.decode(response.body);
    } else {
      throw Exception(response.body.split(','));
    }
    // log.i(response.body, response.body);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formater(url);
    
    String? token = await storage.read(key: "access_token");
    var response = await http.post(
      Uri.parse(url as String),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
        "Connection": "keep-alive"
      },
      // headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "access_token");
    url = formater(url);
    
    var response = await http.patch(
      Uri.parse(url as String),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    
    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    // String token = await storage.read(key: "access_token");
    // url = formater(url);
    // log.d(body);
    var response = await http.post(
      Uri.parse(url as String),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    print(url);
    String? token = await storage.read(key: "access_token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }

  String formater(String url) {
    // return baseurl + url;
    return url;
  }

  // NetworkImage getImage(String imageName) {

  //   // Future<String> token = storage.read(key: "access_token");
  //  Future<String> token =  storage.read(key: "access_token");

  //   Future<String>? baseUrl =  storage.read(key: "baseurl");
  //     Future<String> formaterd(Future<String> url) {
  //     return baseUrl + url;
  //   }

  //   url = formater(url);
  //   String url = formater(
  //       "/api/users/profile/img/${imageName}");
  //   return NetworkImage(
  //     url,
  //     headers: {"Authorization": "Bearer $token"},
  //   );
  // }

  NetworkImage getImage1(String imageName) {
    String url = formater("$imageName.jpg");
    return NetworkImage(url);
  }
}
