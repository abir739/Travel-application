import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'NetworkHandler.dart';
import 'Secreens/Clientcalendar/TravellerFirstScreen.dart';

import 'Secreens/acceuil/welcomPgeGuid.dart';

import 'constent.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
              new Map<String, dynamic>.from(json.decode(response.body));

          print(output["access_token"]);
          print(output["data"]);
          storeAccessToken(output["access_token"]);
          // await storage.write(
          //     key: "access_token", value: output["access_token"]);
          await storage.write(key: "id", value: output["data"]["id"]);
          String Role = output["data"]["role"];
          // Navigator.pushNamed(context, 'register');
          // Get.to(() => GoogleBottomBar());
          if (Role == "Administrator") {
            // Get.to(() => PlaningSecreen());
            Get.to(() => PlaningSecreen());
          } else {
            Get.to(() => TravellerFirstScreen());
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
    }
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
                child: Form(
                  key: formKey,
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
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
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
                                    Navigator.pushNamed(context, 'register');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
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
