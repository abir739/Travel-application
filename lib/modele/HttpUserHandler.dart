import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/constent.dart';
import 'activitsmodel/usersmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpUserHandler {
  final storage = const FlutterSecureStorage();
  String? token = "";
 Future<User> fetchUser(String url, String token) async {
 
    // String? token = await storage.read(key: "access_token");

    String formater(String url) {
    
        return baseUrls + url;

    }

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

}
