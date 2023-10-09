import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/constent.dart';

class HTTPHandler<T> {
  final storage = const FlutterSecureStorage();

  Future<T> fetchData(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    String? baseUrl = await storage.read(key: "baseurl");
    String? token = await storage.read(key: 'access_token');

    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("${response.body} body"); // Print the response body for debugging
      final data = json.decode(response.body);
      final result = fromJson(
          data); // Convert the data using the provided fromJson function
      return result; // Convert the data using the provided fromJson function
    } 
// else if(response.statusCode == 200) {
//        final data = json.decode(response.body);
//    return data; 
//     }
else{
      throw Exception('${response.statusCode}');
    }
  }
}
