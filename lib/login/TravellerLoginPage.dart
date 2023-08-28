import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Secreens/PlannigSecreen.dart';
import '../constent.dart';
import '/Secreens/Clientcalendar/TravellerFirstScreen.dart';

class TravellerLoginPage extends StatefulWidget {
  @override
  _TravellerLoginPageState createState() => _TravellerLoginPageState();
}

class _TravellerLoginPageState extends State<TravellerLoginPage> {
  TextEditingController codeController = TextEditingController();

 void _handleLogin() async {
  String enteredCode = codeController.text.trim();

  if (enteredCode.isNotEmpty) {
    try {
      String? token = await storage.read(key: "access_token");
      String formatter(String url) {
        return baseUrls + url;
      }

      String url = formatter("/api/travellers?filters[code]=$enteredCode");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

     if (response.statusCode == 200) {
        List<dynamic> userList = jsonDecode(response.body);
        Get.to(
          () => TravellerFirstScreen(
            userList: userList,
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch user data.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'An error occurred: $error',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  } else {
    Get.snackbar(
      'Error',
      'Please enter a valid code.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traveller Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter Your Code',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
