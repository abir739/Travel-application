import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Secreens/Clientcalendar/TravellerFirstScreen.dart';

class TravellerLoginPage extends StatefulWidget {
  @override
  _TravellerLoginPageState createState() => _TravellerLoginPageState();
}

class _TravellerLoginPageState extends State<TravellerLoginPage> {
  TextEditingController codeController = TextEditingController();

  void _handleLogin() {
    String enteredCode = codeController.text.trim();
    // Assuming you have a logic to verify the code
    // You can replace this with your actual code verification logic

    if (enteredCode.isNotEmpty) {
      // Navigate to the TravellerFirstScreen
      Get.off(() => TravellerFirstScreen());
    } else {
      // Show an error message if the code is empty
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
