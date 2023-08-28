import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class TravellerLoginPage extends StatefulWidget {
  @override
  _TravellerLoginPageState createState() => _TravellerLoginPageState();
}

class _TravellerLoginPageState extends State<TravellerLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String preFilledEmail = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    emailController.text = preFilledEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your sign-in logic here
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
