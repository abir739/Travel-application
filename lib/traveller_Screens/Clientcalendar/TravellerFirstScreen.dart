import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenify_trip/Secreens/Notification/NotificationCountNotifierProvider.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/activitsmodel/httpActivites.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/transfers_ByVoyMail.dart';
import '../../HTTPHandlerObject.dart';
import '../../modele/httpTravellerbyid.dart';
import '../../modele/traveller/TravellerModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class TravellerFirstScreen extends StatefulWidget {
  final List<dynamic> userList; // Add this parameter

  const TravellerFirstScreen({super.key, required this.userList});

  @override
  _TravellerFirstScreenState createState() => _TravellerFirstScreenState();
}

class _TravellerFirstScreenState extends State<TravellerFirstScreen> {
  late Traveller traveller; // Declare the Traveller variable
  final Travelleruserid = HTTPHandlerTravellerbyId();
  HTTPHandler<Traveller> handler = HTTPHandler<Traveller>();
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  late String? Groupid;

  final count = HTTPHandlerCount();
  int notificationCount = 0;
  static late SharedPreferences prefs;
  int apiCount = 0; // Initialize with a default value
  int inlineCount = 0; // Initialize with a default value
  int reset = 0;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _loadDataTraveller(widget.userList); // Pass the user list
  }

  void refresh() {
    setState(() {
      _loadDataTraveller(
          widget.userList); // Load traveller data when the screen initializes
      _initializeSharedPreferences();
      prefs.setInt('notificationCount', 0);
    });
  }

  Future<void> _initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadDataTraveller(widget.userList);
    // Now you can access prefs globally within this class
//    await  _loadDataTraveller();
//     // Now you can access prefs globally within this class
    count
        .fetchInlineCount(
            "/api/push-notificationsMobile?filters[tagsGroups]=${traveller.touristGroupId}")
        .then((result) {
      setState(() {
        inlineCount = result;
      });
      print('Inline Count: $result'); // Print the result
    }).catchError((error) {
      print('Error: $error'); // Handle errors if any
    });
    // setState(() {});
    setState(() {});
  }

  Future<void> logout() async {
    // Delete sensitive data from secure storage
    await storage.deleteAll();
    Get.offNamed('login');
  }

  Future<void> sendtags(String? Groupids) async {
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
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator or any other widget while waiting
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 219, 10, 10),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 24, 10, 221)),
                    ),
                  );
                } else {
                  // After the delay, show the "Submit" button
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('session Tim out.... ',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Color.fromARGB(255, 90, 3, 203))),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.red, // Change the text color
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
                            // await storage.delete(key: "access_token");
                            // await storage.delete(key: "id");
                            // await storage.delete(key: "role");
                            await storage.deleteAll();

                            Get.to(() => const MyLogin());
                          },
                          child: const Text('Logout'),
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
                SvgPicture.asset(
                  'assets/Frame.svg',
                  fit: BoxFit.cover,
                  height: 36.0,
                ),
                const SizedBox(width: 80),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF3A3557),
                        Color(0xFFCBA36E),
                        Color(0xFFEB5F52),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Zenify Trip',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors
                          .white, // You can adjust the font size and color here
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Stack(children: [
                Row(children: [
                  badges.Badge(
                    position: badges.BadgePosition.topStart(top: 2, start: 0.5),
                    badgeContent: FutureBuilder<int>(
                      future: count.fetchInlineCount(
                        "/api/push-notificationsMobile?filters[tagsGroups]=${traveller.touristGroupId}",
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while fetching the inline count
                          return CircularProgressIndicator(strokeWidth: 1.0);
                        }
                        if (snapshot.hasError) {
                          // Handle the error if the inline count couldn't be fetched
                          return Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        final apiCount = snapshot.data ?? 0;

                        // Use the apiCount value here

                        // Return your widget, e.g., combine it with the Consumer widget
                        return Consumer<NotificationCountNotifier>(
                          builder: (context, notifier, child) {
                            // Display the notification count using Text widget
                            final combinedCount = apiCount + notifier.count;
                            // Save the combined count to SharedPreferences

                            // prefs.setInt('notificationCount', combinedCount);
                            if (combinedCount > (apiCount + notifier.count)) {
                              final resulta = combinedCount - notificationCount;
                              setState(() {
                                prefs.setInt(
                                    'notificationCount', combinedCount);
                              });
                              return Text(
                                '${notifier.count.abs()}',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            } else {
                              reset = combinedCount - apiCount;

                              return Text(
                                '${reset.abs()}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }
                          },
                        );
                      },
                    ),
                    child: IconButton(
                      color: Color.fromARGB(255, 8, 8, 8),
                      iconSize: 40,
                      icon: Icon(Icons.notifications),
                      onPressed: () async {
                        await count
                            .fetchInlineCount(
                                "/api/push-notificationsMobile?filters[tagsGroups]=${traveller.touristGroupId}")
                            .then((result) {
                          setState(() {
                            // inlineCount = result;

                            prefs.setInt('notificationCount', 0);
                            reset = 0;
                          });
                          print('Inline Count: $result'); // Print the result
                        }).catchError((error) {
                          print('Error: $error'); // Handle errors if any
                        });
                        // prefs.setInt('notificationCount', 0);
                        //  await resetNotificationCount(); // Reset notification count to 0
                        // await Get.off(TravellerFirstScreen());
                        // Future.delayed(Duration(milliseconds: 100), () {
                        //   refresh();
                        Get.toNamed('notificationScreen', arguments: {
                          'touristGroupId': traveller.touristGroupId
                        });
                        // });
                      },
                      // color: Color.fromARGB(219, 39, 38, 40),
                    ),
                  ),
                ]),
              ])
            ]),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF3A3557),
                        Color(0xFFCBA36E),
                        Color(0xFFEB5F52),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Welcome to the Traveller First Screen!',
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors
                            .white), // You can adjust the font size and color here
                  ),
                ),

                const SizedBox(height: 20),
                // Display traveller data if available
                Column(
                  children: [
                    Consumer<NotificationCountNotifier>(
                      builder: (context, notifier, child) {
                        // Display the notification count using Text widget
                        return Text(
                          'Notification Count: ${notifier.count} $notificationCount',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Set the text color to black
                          height:
                              2.0, // Adjust this value to control line spacing
                        ),
                        children: [
                          const TextSpan(
                            text: 'Traveller Group ID: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '\n${traveller.touristGroupId}\n', // Added '\n' here
                          ),
                          const TextSpan(
                            text: 'Traveller Code: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${traveller.code}\n', // Added '\n' here
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // This provides space between RichText and the next element
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
                    Get.to(() => TravellerCalendarPage(
                          group: traveller.touristGroupId,
                        ));
                    Navigator.pushNamed(context, 'TravellerCalendarPage');
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFEB5F52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    logout();
                  },
                  child: const Center(
                    child: Text(
                      'Logout ',
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
