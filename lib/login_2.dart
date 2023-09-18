import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker_nm/flutter_country_picker_nm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';
import 'NetworkHandler.dart';
import 'Secreens/PlannigSecreen.dart';
import 'Secreens/guidPlannig.dart';
import 'constent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

//  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
// final _globalkey = GlobalKey<FormState>();
TextEditingController emailControllerForget = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController confirmController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
Country? _selected;
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController urlc = TextEditingController();
int selectedRadio = 0;
TextEditingController forgetEmailController = TextEditingController();
bool circular = false;
late String errorText;
bool validate = false;
NetworkHandler networkHandler = NetworkHandler();
final storage = new FlutterSecureStorage();

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    emailControllerForget = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    initPlatformState();
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
  }

  Future<void> sendPasswordResetEmailRequest(String email) async {
    final response = await http.post(
      Uri.parse(
          '${baseUrls}/api/auth/forgot-password'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      await showResetDialogEmail(email);
      // Password reset request was successful
      // Provide feedback to the user (e.g., show a success message)
      print('Password reset request sent successfully');
    } else {
      // Password reset request failed
      // Handle the error and provide feedback to the user
      print('Failed to send password reset request');
    }
  }

  Future<void> showResetDialogEmail(String email) async {
    final TextEditingController resetTokenController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password via Email'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: resetTokenController,
                decoration: InputDecoration(labelText: 'Enter Reset Token'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the reset token';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the new password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Form is valid, proceed with sending the reset request via email
                final resetResponse = await http.post(
                  Uri.parse(
                      '${baseUrls}/api/auth/reset-password/${resetTokenController.text}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'email': email,
                    'newPassword': newPasswordController.text,
                  }),
                );

                if (resetResponse.statusCode == 201) {
                  // Password reset was successful
                  // Provide feedback to the user (e.g., show a success message)
                  print('Password reset via email successful');
                  Navigator.pop(context); // Close the dialog
                } else {
                  // Password reset request via email failed
                  // Handle the error and provide feedback to the user
                  print('Failed to reset password via email');
                }
              }
            },
            child: Text('Reset Password via Email'),
          ),
        ],
      ),
    );
  }

  Future<void> showResetDialog(String phoneNumber) async {
    final TextEditingController codeController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Enter Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the new password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
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
                  Navigator.pop(context); // Close the dialog
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
    );
  }

  Future<void> sendPasswordResetRequest(String phoneNumber) async {
    print('$phoneNumber phoneNumber');
    final response = await http.post(
      Uri.parse(
          '${baseUrls}/api/auth/send-sms'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      await showResetDialog(phoneNumber);
      // Password reset request was successful
      // Provide feedback to the user (e.g., show a success message)
      print('Password reset request sent successfully');
    } else {
      // Password reset request failed
      // Handle the error and provide feedback to the user
      print('Failed to send password reset request');
    }
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      oneSignalAppId,
      // iOSSettings: {
      //   OSiOSSettings.autoPrompt: true,
      //   OSiOSSettings.inAppLaunchUrl: true
      // },
    );

    // OneSignal.shared
    //     .(OSNotificationDisplayType.notification);

    //This method only work when app is in foreground.
    // OneSignal.shared.setNotificationOpenedHandler(
    //   (OSNotificationOpenedResult notification) {
    //     print("${notification.notification.body} actions");
    //     // Extract data from the notification payload
    //     Map<String, dynamic>? additionalData =
    //         notification.notification.additionalData;
    //     print("${additionalData} additionalData");

    //     // Parse the JSON string
    //     // Map<String, dynamic> bodyData = json.decode(body!);

    //     // Navigate to the desired screen based on payload data
    //     if (additionalData!.containsKey('screen')) {
    //       String screenName = additionalData['screen'];
    //       print("$screenName      print(screenName);");
    //       // Navigator.of(notification.context).pushNamed(screenName);
    //       Get.toNamed(screenName);
    //     }
    //   },
    // );
    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   OSNotification notification1 = result.notification;

    //   OSNotification notification = result.notification;
    //   OSNotificationAction? action = result.action;

    //   // Access notification properties
    //   String notificationId = notification.notificationId;
    //   String? title = notification.title;
    //   String? body = notification.body;
    //   Map<String, dynamic>? additionalData = notification.additionalData;

    //   // Access action properties
    //   OSNotificationActionType? actionType = action?.type;
    //   String? actionId = action?.actionId;
    //   // Map<String, dynamic>? actionData = action?.additionalData;
    //   print('title $title bodys $body actionType $actionType');
    //   // Perform your desired actions based on the notification and action data
    //   // Navigator.push(context, MaterialPageRoute(builder: (_) => Planingtest()));
    // });
    // OneSignal.shared.setNotificationOpenedHandler(
    //   (OSNotificationOpenedResult result) async {
    //     var data = result.notification.additionalData;
    //     // globals.appNavigator.currentState.push(
    //     // MaterialPageRoute(
    //     //   builder: (context) => SecondPage(
    //     //     postId: data['post_id'].toString(),
    //     //   ),
    //     // ),
    //     // );
    //   },
    // );
  }

  void _showCountryPickerDialog(BuildContext context) {
    Country? selectedCountry;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Country'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CountryPicker(
                showDialingCode: true,
                onChanged: (Country country) {
                  setState(() {
                    selectedCountry = country;
                  });
                },
                selectedCountry: selectedCountry,
              ),
              SizedBox(height: 16.0),
              Text(
                'Selected Country: ${selectedCountry?.name}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle the action when the "Confirm" button is pressed
                if (selectedCountry != null) {
                  setState(() {
                    _selected = selectedCountry;
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without selecting a country
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _requestPermission() async {
    final status = await Permission.storage.request();
    print(status);
  }

  Future<void> storeAccessToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: token);
    print(token);
  }

  void _handleLogin() async {
    // if (formKey.currentState!.validate()) {
    Map<String, String> data = {
      "username": emailController.text,
      "password": passwordController.text,
    };
    try {
      var response =
          await networkHandler.post("${baseUrls}/api/auth/login", data);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output =
            new Map<String, dynamic>.from(json.decode(response.body));

        print(output["access_token"]);
        print(output["data"]);
        storeAccessToken(output["access_token"]);
        // await storage.write(
        //     key: "access_token", value: output["access_token"]);
        await storage.write(key: "id", value: output["data"]["id"]);
        await storage.write(key: "Role", value: output["data"]["role"]);
        String? Role = output["data"]["role"];
        // Navigator.pushNamed(context, 'register');
        // Get.to(() => GoogleBottomBar());
        if (Role == "Administrator") {
          Get.off(() => PlaningSecreen());
        } else {
          Get.off(() => TravellerFirstScreen(userList: [],));
        }
      } else {
        Map<String, dynamic> output =
            new Map<String, dynamic>.from(json.decode(response.body));

        print(output);
        Get.snackbar('Warning', '$errorText',
            colorText: Colors.white,
            backgroundColor: Color.fromARGB(255, 185, 4, 4));
      }
    } catch (error) {
      print('Network request failed: $error');
      Get.snackbar('Warning', '$error',
          backgroundGradient: LinearGradient(
            colors: [Color(0xff979090), Color(0x31858489)],
          ),
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 185, 4, 4));
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                // child: Form(
                //   key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            style: TextStyle(),
                            obscureText: true,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: _handleLogin,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.offNamed('register');
                                },
                                child: Text(
                                  'Connect with Code Sv.. ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Reset Password'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Reset Password via ...'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        emailControllerForget,
                                                    decoration: InputDecoration(
                                                      labelText: 'Enter Email',
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // User chose to reset password via email
                                                      sendPasswordResetEmailRequest(
                                                          emailControllerForget
                                                              .text);
                                                      // Navigator.pop(context);
                                                    },
                                                    child:
                                                        Text('Reset via Email'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xff4c505b),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     // User chose to reset password via phone number
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (context) => AlertDialog(
                                      //         title: Text('Forgot Password'),
                                      //         content: TextField(
                                      //           controller:
                                      //               phoneNumberController,
                                      //           decoration: InputDecoration(
                                      //             labelText: 'Phone Number',
                                      //           ),
                                      //         ),
                                      //         actions: [
                                      //           ElevatedButton(
                                      //             onPressed: () {
                                      //               print(
                                      //                   '${phoneNumberController.text}');
                                      //               sendPasswordResetRequest(
                                      //                   phoneNumberController
                                      //                       .text);
                                      //               Navigator.pop(context);
                                      //             },
                                      //             child:
                                      //                 Text('Send Reset Code'),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   },
                                      //   child: Text(
                                      //     'Reset via Phone Number',
                                      //     style: TextStyle(
                                      //       decoration:
                                      //           TextDecoration.underline,
                                      //       color: Color(0xff4c505b),
                                      //       fontSize: 18,
                                      //     ),
                                      //   ),
                                      // ),
                                      // Text(
                                      //   'Selected Country: ${_selected?.name ?? "None"}',
                                      //   style: TextStyle(fontSize: 18.0),
                                      // ),
                                      
TextButton(
                                        onPressed: () async {
                                          Get.offNamed(
                                             'resetPassword')!.then((value) =>  Navigator.pop(
                                                context));
                                          // Show the country picker dialog
                                          // setState(() {
                                            // Close the screen
                                          //   //  _showCountryPickerDialog(context);
                                          // });
                                        },
                                        child: Text('Reset Password via phone'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Reset Password via Mail',
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
                  ],
                ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
