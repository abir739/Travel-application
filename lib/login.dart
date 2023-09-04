import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';
import 'package:zenify_trip/Secreens/acceuil/welcomPgeGuid.dart';
import 'NetworkHandler.dart';

import 'Secreens/PlannigSecreen.dart';

import 'constent.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
// final _globalkey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController confirmController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();

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
    emailController = TextEditingController();
    passwordController = TextEditingController();
    initPlatformState();
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      oneSignalAppId,
    );

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      OSNotification notification1 = result.notification;

      OSNotification notification = result.notification;
      OSNotificationAction? action = result.action;

      // Access notification properties
      String notificationId = notification.notificationId;
      String? title = notification.title;
      String? body = notification.body;
      Map<String, dynamic>? additionalData = notification.additionalData;

      // Access action properties
      OSNotificationActionType? actionType = action?.type;
      String? actionId = action?.actionId;
      // Map<String, dynamic>? actionData = action?.additionalData;
      print('title $title bodys $body actionType $actionType');
    });
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) async {
        var data = result.notification.additionalData;
      },
    );
  }

  void _requestPermission() async {
    final status = await Permission.storage.request();
    print(status);
  }

  Future<void> storeAccessToken(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: token);
    print(token);
  }

  void _handleLogin() async {
    if (formKey.currentState!.validate()) {
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
              Map<String, dynamic>.from(json.decode(response.body));

          print(output["access_token"]);
          print(output["data"]);
          storeAccessToken(output["access_token"]);
          // await storage.write(
          //     key: "access_token", value: output["access_token"]);
          await storage.write(key: "id", value: output["data"]["id"]);
          await storage.write(key: "Role", value: output["data"]["role"]);
          String Role = output["data"]["role"];
          // Navigator.pushNamed(context, 'register');
          // Get.to(() => GoogleBottomBar());
          if (Role == "Administrator") {
            Get.off(() => const PlaningSecreen());
          } else {
            Get.off(() => TravellerFirstScreen(
                  userList: [],
                ));
          }
        } else {
          Map<String, dynamic> output =
              Map<String, dynamic>.from(json.decode(response.body));

          print(output);
          Get.snackbar('Warning', errorText,
              colorText: Colors.white,
              backgroundColor: const Color.fromARGB(255, 185, 4, 4));
        }
      } catch (error) {
        print('Network request failed: $error');
        Get.snackbar('Warning', '$error',
            backgroundGradient: const LinearGradient(
              colors: [Color(0xff979090), Color(0x31858489)],
            ),
            colorText: Colors.white,
            backgroundColor: const Color.fromARGB(255, 185, 4, 4));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 55, top: 150),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
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
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: const TextStyle(),
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
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: _handleLogin,
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register');
                                  },
                                  style: const ButtonStyle(),
                                  child: const Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18,
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
