import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zenify_trip/NetworkHandler.dart';
import 'package:zenify_trip/Secreens/guidPlannig.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';
import 'package:http/http.dart' as http;
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

bool _showPassword = false;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController emailControllerForget = TextEditingController();
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
final storage = FlutterSecureStorage();
const String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
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
  }

  void _requestPermission() async {
    final status = await Permission.storage.request();
    print(status);
  }

  Future<void> storeAccessToken(String token) async {
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
            await networkHandler.post("$baseUrls/api/auth/login", data);

        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> output =
              Map<String, dynamic>.from(json.decode(response.body));

          print(output["access_token"]);
          print(output["data"]);
          storeAccessToken(output["access_token"]);
          await storage.write(key: "id", value: output["data"]["id"]);
          await storage.write(key: "Role", value: output["data"]["role"]);
          String? Role = output["data"]["role"];
          if (Role == "Administrator") {
            Get.off(() => const PlaningSecreen());
          } else {
            Get.off(() => const TravellerFirstScreen(
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

  Future<void> sendPasswordResetEmailRequest(String email) async {
    final response = await http.post(
      Uri.parse('${baseUrls}/api/auth/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      await showResetDialogEmail(email);
      print('Password reset request sent successfully');
    } else {
      print('Failed to send password reset request');
    }
  }

  Future<void> showResetDialogEmail(String email) async {
    final TextEditingController resetTokenController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Reset Password',
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: resetTokenController,
              decoration:
                  const InputDecoration(labelText: '  Enter Reset Token'),
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
              decoration: const InputDecoration(labelText: '  New Password'),
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
      btnOkText: 'Reset Password',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        if (formKey.currentState!.validate()) {
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
            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              title: 'Success',
              desc: 'Password reset via email successful',
              btnOkText: 'OK',
              btnOkColor: Colors.green,
              dismissOnTouchOutside: true,
            ).show();
            Navigator.pop(context);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              title: 'Error',
              desc: 'Failed to reset password via email',
              btnOkText: 'OK',
              btnOkColor: const Color(0xff979090),
              dismissOnTouchOutside: true,
            ).show();
          }
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: RotatedBox(
              quarterTurns: 4,
              child: Stack(
                children: [
                  WaveWidget(
                    config: CustomConfig(
                      gradients: [
                        [const Color(0xFF3A3557), const Color(0xFFEB5F52)],
                        [const Color(0xFFEB5F52), const Color(0xFFCBA36E)],
                      ],
                      durations: [19440, 10800],
                      heightPercentages: [0.05, 0.25],
                      blur: const MaskFilter.blur(BlurStyle.solid, 10),
                      gradientBegin: Alignment.center,
                      gradientEnd: Alignment.topRight,
                    ),
                    waveAmplitude: 10,
                    size: const Size(
                      double.infinity,
                      double.infinity,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 55, top: 150),
                    child: const Text(
                      'Welcome\nBack',
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                ],
              ),
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
                            obscureText: !_showPassword,
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
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                ' Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 250, 252),
                                child: IconButton(
                                    color:
                                        const Color.fromARGB(255, 12, 12, 12),
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
                                    color: Colors
                                        .white, // Specify the color property here
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: emailControllerForget,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Reset Password via mail',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // User chose to reset password via email
                                            sendPasswordResetEmailRequest(
                                                emailControllerForget.text);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Reset Password'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color.fromARGB(255, 17, 17, 17),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
