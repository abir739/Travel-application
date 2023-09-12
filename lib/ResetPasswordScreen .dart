import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constent.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String phoneNumber;

  ResetPasswordScreen({required this.phoneNumber});
  String? validatePasswordStrength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check if the password contains at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check if the password contains at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check if the password contains at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }

    // Check if the password contains at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null; // Password meets the criteria
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Code'),
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return 'Please enter the code';
                }
                return null;
              },
            ),
            TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: validatePasswordStrength),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Form is valid, proceed with sending the reset request
                  final resetResponse = await http.post(
                    Uri.parse(
                        '${baseUrls}/api/auth/reset-Code/${codeController.text}'), // Replace with your reset endpoint
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'phoneNumber': phoneNumber,
                      'newPassword': newPasswordController.text,
                    }),
                  );

                  if (resetResponse.statusCode == 201) {
                    // Reset password was successful
                    // Provide feedback to the user (e.g., show a success message)
                    print('Password reset successful');
                    Navigator.pop(context); // Close the screen
                  } else {
                    // Reset password request failed
                    // Handle the error and provide feedback to the user
                    print('Failed to reset password');
                  }
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
