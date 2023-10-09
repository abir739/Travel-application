import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_country_picker_nm/flutter_country_picker_nm.dart';
import 'package:http/http.dart' as http;

import 'ResetPasswordScreen .dart';
import 'services/constent.dart';

class ResetPasswordWithPhoneNumberScreen extends StatefulWidget {
  const ResetPasswordWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordWithPhoneNumberScreenState createState() =>
      _ResetPasswordWithPhoneNumberScreenState();
}

class _ResetPasswordWithPhoneNumberScreenState
    extends State<ResetPasswordWithPhoneNumberScreen> {
  Country? _selected;
  bool selected = false;
  bool sendode = false;
  TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController? phoneNumberController; // Declare as nullable
  // Future<void> showResetDialog(String phoneNumber) async {
  //   final TextEditingController codeController = TextEditingController();
  //   final TextEditingController newPasswordController = TextEditingController();
  //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Reset Password'),
  //       content: Form(
  //         key: formKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextFormField(
  //               controller: codeController,
  //               decoration: InputDecoration(labelText: 'Enter Code'),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter the code';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             TextFormField(
  //               controller: newPasswordController,
  //               decoration: InputDecoration(labelText: 'New Password'),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter the new password';
  //                 }
  //                 return null;
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (formKey.currentState!.validate()) {
  //               // Form is valid, proceed with sending the reset request
  //               final resetResponse = await http.post(
  //                 Uri.parse(
  //                     'http://192.168.1.29:3000/api/auth/reset-Code/${codeController.text}'), // Replace with your reset endpoint
  //                 headers: <String, String>{
  //                   'Content-Type': 'application/json',
  //                 },
  //                 body: jsonEncode(<String, dynamic>{
  //                   'phoneNumber': phoneNumber,
  //                   'newPassword': newPasswordController.text,
  //                 }),
  //               );

  //               if (resetResponse.statusCode == 201) {
  //                 // Reset password was successful
  //                 // Provide feedback to the user (e.g., show a success message)
  //                 print('Password reset successful');
  //                 Navigator.pop(context); // Close the dialog
  //               } else {
  //                 // Reset password request failed
  //                 // Handle the error and provide feedback to the user
  //                 print('Failed to reset password');
  //               }
  //             }
  //           },
  //           child: Text('Reset Password'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    phoneNumberController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController!.dispose();
    super.dispose();
  }

  // bool isButtonEnabled() {
  //   // Check if the phone number has more than 5 characters
  //   return phoneNumberController!.text.length > 5;
  // }
  Future<void> sendPasswordResetRequest(String phoneNumber) async {
    print('$phoneNumber phoneNumber');
    final response = await http.post(
      Uri.parse(
          "${baseUrls}/api/auth/send-sms"), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phoneNumber': phoneNumber,
      }),
    );
    Map<String, dynamic> output =
        new Map<String, dynamic>.from(json.decode(response.body));

    print(output["messages"]);
    print(output["messages"]);
    print(output["messages"]);
    if (response.statusCode == 201) {
      // await showResetDialog(phoneNumber);
      setState(() {
        sendode = true;
      });
      // Password reset request was successful
      // Provide feedback to the user (e.g., show a success message)
      print('Password reset request sent successfully');
    } else {
      // Password reset request failed
      // Handle the error and provide feedback to the user
      print('Failed to send password reset request');
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKeys = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password with Phone Number'),
      ),
      body:
Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CountryPicker(
              showDialingCode: true,
              onChanged: (Country country) {
                setState(() {
                  _selected = country;
                  selected = true;
                });
              },
              selectedCountry: _selected,
            ),
            SizedBox(height: 16.0),
            Text(
              'Selected Country: ${_selected?.name ?? "None"}',
              style: TextStyle(fontSize: 18.0),
            ),
            selected
                ? Form(
                    // Wrap with a Form widget
                    key: formKeys, // Assign the GlobalKey
                    child: Column(
                      children: [
                        TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length < 6) {
                              return 'number mustbe < 6';
                            }
                            // You can add more validation rules here if needed
                            return null;
                          },
                        ),
//                         ElevatedButton(
//                           onPressed: ()async {
//                             // User chose to reset password via phone number
//                             // final phoneNumber = phoneNumberController!.text;
//                             // print('Phone number: $phoneNumber');
//                             // if (formKeys.currentState!.validate() ) {
//  final phoneNumber = '+${_selected?.dialingCode}${phoneNumberController!.text}';
    
//     // Send the password reset request
//     await sendPasswordResetRequest(phoneNumber);

//     // Check if the response messages indicate success
//     if (sendode) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResetPasswordScreen(
//             phoneNumber: phoneNumber,
//           ),
//         ),
//       );
//     }
//                             }
//                           // }, // Disable the button if the condition is not met
//                           ,child: Text(
//                             'Reset via Phone Number +${_selected?.dialingCode ?? 'Us'}',
//                             style: TextStyle(
//                               decoration: TextDecoration.underline,
//                               color: Color(0xff4c505b),
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
                    ElevatedButton(
                          onPressed: () async {
                            final phoneNumber =
                                '+${_selected?.dialingCode}${phoneNumberController!.text}';

                            // Validate the form
                            if (formKeys.currentState!.validate()) {
                              // Send the password reset request
                              await sendPasswordResetRequest(phoneNumber);

                              // Check if the response messages indicate success
                              if (sendode) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen(
                                      phoneNumber: phoneNumber,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Reset via Phone Number +${_selected?.dialingCode}',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xff4c505b),
                              fontSize: 18,
                            ),
                          ),
                        )
  ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
