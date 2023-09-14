import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:zenify_trip/guide_Screens/firstpage.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerFirstScreen.dart';
import 'NetworkHandler.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'Secreens/guidPlannig.dart';
import 'constent.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

bool _showPassword = false;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController resetCodeController = TextEditingController();
bool receivedResetCode = false;
final TextEditingController newPasswordController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController emailtester = TextEditingController();
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
const storage = FlutterSecureStorage();
const String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    emailController = TextEditingController();
    emailtester = TextEditingController();
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
      // iOSSettings: {
      //   OSiOSSettings.autoPrompt: true,
      //   OSiOSSettings.inAppLaunchUrl: true
      // },
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
            await networkHandler.post("$baseUrls/api/auth/login", data);

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
          String? Role = output["data"]["role"];
          // Navigator.pushNamed(context, 'register');
          // Get.to(() => GoogleBottomBar());
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

  void _handlePassword() async {
    Map<String, String> data = {
      "email": "abir.cherif@ensi-uma.tn",
    };
    try {
      print(emailtester.text);
      var response =
          await networkHandler.post("$baseUrls/api/auth/forgot-password", data);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output =
            Map<String, dynamic>.from(json.decode(response.body));

        print(output["message"]);
      } else {
        Map<String, dynamic> output =
            Map<String, dynamic>.from(json.decode(response.body));

        print(output);

        // Display an error message using Get.snackbar or any other method you prefer.
        Get.snackbar('Warning', 'Error: ${output["message"]}',
            colorText: Colors.white,
            backgroundColor: const Color.fromARGB(255, 185, 4, 4));
      }
    } catch (error) {
      print('Network request failed: $error');
      Get.snackbar('Warning', 'Network request failed: $error',
          backgroundGradient: const LinearGradient(
            colors: [Color(0xff979090), Color(0x31858489)],
          ),
          colorText: Colors.white,
          backgroundColor: const Color.fromARGB(255, 185, 4, 4));
    }
  }

  void _handleSendResetEmail() async {
    String userEmail = emailController.text;
    Map<String, String> data = {
      "email": userEmail,
    };

    try {
      var response =
          await networkHandler.post("$baseUrls/api/auth/forgot-password", data);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 24.0, // Increase title font size
                  fontWeight: FontWeight.bold, // Make title bold
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Code input field
                  TextFormField(
                    controller: resetCodeController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Code",
                      labelText: "Verification Code", // Add a label for clarity
                      border:
                          OutlineInputBorder(), // Add border to the input field
                    ),
                  ),
                  const SizedBox(height: 16), // Add some spacing
                  // Email input field
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      labelText: "Email Address", // Add a label for clarity
                      border:
                          OutlineInputBorder(), // Add border to the input field
                    ),
                  ),
                  const SizedBox(height: 16), // Add some spacing
                  // New password input field
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "New Password",
                      labelText: "New Password", // Add a label for clarity
                      border:
                          OutlineInputBorder(), // Add border to the input field
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Handle password reset logic here
                    _handleResetPassword();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 16.0, // Increase button font size
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16.0, // Increase button font size
                      color: Colors.red, // Change button text color
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Handle error here if needed.
      }
    } catch (error) {
      // Handle network error.
    }
  }

  void _handleResetPassword() async {
    String resetCode = resetCodeController.text;
    Map<String, String> data = {
      "resetToken": resetCode,
    };

    try {
      var response = await networkHandler.post(
          "$baseUrls/api/auth/reset-password/$resetCode", data);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output =
            Map<String, dynamic>.from(json.decode(response.body));

        print(output["message"]);
        // Handle success, e.g., show a success message to the user.
      } else {
        Map<String, dynamic> output =
            Map<String, dynamic>.from(json.decode(response.body));

        print(output);
        // Handle error, e.g., show an error message to the user.
      }
    } catch (error) {
      print('Network request failed: $error');
      // Handle network error, e.g., show a network error message to the user.
    }
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
                            obscureText:
                                !_showPassword, // Use a boolean to toggle password visibility
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
                              // Add the eye icon to toggle password visibility
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
                                'Sign in',
                                style: TextStyle(
                                  color: Colors
                                      .white, // Specify the color property here
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
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          receivedResetCode
                                              ? "Reset Password"
                                              : "Send Reset Email",
                                          style: const TextStyle(
                                            fontSize:
                                                24.0, // Increase title font size
                                            fontWeight: FontWeight
                                                .bold, // Make title bold
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!receivedResetCode)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                child: Text(
                                                  "Please enter your email to reset your password:",
                                                  style: TextStyle(
                                                    fontSize:
                                                        16.0, // Increase text font size
                                                  ),
                                                ),
                                              ),
                                            if (receivedResetCode)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                child: Text(
                                                  "Please enter the code you received:",
                                                  style: TextStyle(
                                                    fontSize:
                                                        16.0, // Increase text font size
                                                  ),
                                                ),
                                              ),
                                            TextFormField(
                                              controller: receivedResetCode
                                                  ? resetCodeController
                                                  : emailController,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                hintText: receivedResetCode
                                                    ? "Code"
                                                    : "Email",
                                                labelText: receivedResetCode
                                                    ? "Verification Code"
                                                    : "Email Address", // Add a label for clarity
                                                border:
                                                    const OutlineInputBorder(), // Add border to the input field
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (!receivedResetCode) {
                                                _handleSendResetEmail();
                                                receivedResetCode =
                                                    true; // Update to show code input field
                                              } else {
                                                _handleResetPassword();
                                                receivedResetCode =
                                                    false; // Reset the state for the next email
                                              }
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Text(
                                              receivedResetCode
                                                  ? "Reset Password"
                                                  : "Send Email",
                                              style: const TextStyle(
                                                fontSize:
                                                    16.0, // Increase button font size
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize:
                                                    16.0, // Increase button font size
                                                color: Colors
                                                    .red, // Change button text color
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
