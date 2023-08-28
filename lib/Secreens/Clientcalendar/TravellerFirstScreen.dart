import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_svg/svg.dart';
import '../../HTTPHandlerObject.dart';
import '../../modele/httpTravellerbyid.dart';
import '../../modele/traveller/TravellerModel.dart';
// import 'TravellerCalender.dart';
import 'package:get/get.dart';

import 'TravellerCalender_test.dart';

class TravellerFirstScreen extends StatefulWidget {
  final List<dynamic> userList; // Add this parameter

  TravellerFirstScreen({required this.userList});

  @override
  _TravellerFirstScreenState createState() => _TravellerFirstScreenState();
}

class _TravellerFirstScreenState extends State<TravellerFirstScreen> {
  late Traveller traveller; // Declare the Traveller variable
  final Travelleruserid = HTTPHandlerTravellerbyId();
  HTTPHandler<Traveller> handler = HTTPHandler<Traveller>();
  final storage = new FlutterSecureStorage();
  bool isLoading = true;
  late String? Groupid;
  @override
  void initState() {
    super.initState();
    _loadDataTraveller(widget.userList); // Pass the user list
  }

  Future<void> sendtags(String? Groupids) async {
    await OneSignal.shared.sendTags({'$Groupids': '$Groupids'}).then((success) {
      print("Tags created successfully $Groupids");
    }).catchError((error) {
      print("Error creating tags: $error");
    });
    setState(() {
      OneSignal.shared.sendTags({'Groupids': '$Groupids'}).then((success) {
        print("Tags created successfully $Groupids");
      }).catchError((error) {
        print("Error creating tags: $error");
      });

      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      });
    });
  }

  Future<Traveller> _loadDataTraveller(List<dynamic> userList) async {
    final userId = await storage.read(key: "id");

    final travellerdetail = await handler.fetchData(
        "/api/travellers/UserId/$userId", Traveller.fromJson);

    setState(() {
      traveller = travellerdetail;
      print(travellerdetail.id);
      isLoading = false;
      Groupid = traveller.touristGroupId;
      // _loadDatagroup();
      sendtags(Groupid);
    });
    return travellerdetail;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          child: Center(
            child: FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator or any other widget while waiting
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 219, 10, 10),
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 24, 10, 221)),
                    ),
                  );
                } else {
                  // After the delay, show the "Submit" button
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: Get.width * 0.7,
                        // ),
                        const Text('session Tim out.... ',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Color.fromARGB(255, 90, 3, 203))),
                        ElevatedButton(
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .red, // Change the button's background color
                            onPrimary: Colors.white, // Change the text color
                            textStyle: const TextStyle(
                                fontSize: 16), // Change the text style
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16), // Adjust the padding
                            minimumSize: const Size(120,
                                40), // Set a minimum width and height for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                          ),
                          onPressed: () async {
                            await storage.delete(key: "access_token");
                            // Get.to(LoginView());
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 207, 207, 219),
          title: Row(
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Zenify', // Your text
                    textStyle: const TextStyle(
                      fontSize: 26,
                      letterSpacing: 24,
                      color: Color.fromARGB(255, 68, 5, 150),
                    ),
                    speed: const Duration(
                        milliseconds: 200), // Adjust the animation speed
                  ),
                ],
                totalRepeatCount:
                    5, // Set the number of times the animation will repeat
                pause: const Duration(
                    milliseconds:
                        1000), // Duration before animation starts again
                displayFullTextOnTap: true, // Display full text when tapped
              ),
              SvgPicture.asset(
                'assets/Frame.svg',
                fit: BoxFit.cover,
                height: 36.0,
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the Traveller First Screen!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                if (traveller != null) // Display traveller data if available
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Set the text color to black
                          ),
                          children: [
                            const TextSpan(
                              text: 'Traveller ID: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '\n${traveller.id}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFEB5F52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Add any navigation logic here
                    Get.to(TravellerCalendarPage(
                      group: traveller.touristGroupId,
                    ));
                  },
                  child: const Center(
                    child: Text(
                      'Navigate ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
