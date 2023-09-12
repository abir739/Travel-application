import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenify_trip/NetworkHandler.dart';
import 'package:zenify_trip/guide_Screens/calendar/menu.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import '../modele/HttpPlaning.dart';
import '../modele/TouristGuide.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/httpToristGroup.dart';
import '../modele/activitsmodel/httpToristguid.dart';
import '../modele/httpTouristguidByid.dart';
import '../modele/httpTravellerbyid.dart';
import '../modele/planningmainModel.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../modele/traveller/TravellerModel.dart';
import 'TouristGroupProvider.dart';

class PlaningSecreen extends StatefulWidget {
  const PlaningSecreen({super.key});

  @override
  State<PlaningSecreen> createState() => _PlaningSecreenState();
}

class _PlaningSecreenState extends State<PlaningSecreen> {
  TextEditingController groupkeycontroller = TextEditingController();
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final _globalkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  int selectedRadio = 0;
  TouristGuide? guid;
  late Traveller travller;
  TextEditingController forgetEmailController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  final httpHandler = HTTPHandlerhttpToristguid();
  final guidbyuserid = HTTPHandlerToristGuidbyId();
  final Travelleruserid = HTTPHandlerTravellerbyId();
  // String baseUrl = "http://192.168.1.14:3000/";
  // final httpHandler = HTTPHandlerhttpToristguid();
  final httpHandlertoristguid = HTTPHandlerhttpToristguid();
  final httpHandlertorist = HTTPHandlerhttpGroup();
  final httpHandlerPlanning = HTTPHandlerplaning();
  final count = HTTPHandlerCount();
  // late List<TouristGuide> touristGuides;
  // late TouristGuide selectedTouristGuide;
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? touristGroup;
  List<PlanningMainModel>? planning;
  TouristGuide? selectedTouristGuide = TouristGuide();
  TouristGroup? selectedTouristGroup = TouristGroup();
  PlanningMainModel? selectedPlanning = PlanningMainModel();
  final TouristGroupProvider _touristGroupProvider = TouristGroupProvider();
// TouristGuide? selectedTouristGuide=
// TouristGuide(
//   id: "default_id",
//   name: "default_name",
//   fullName: "default_full_name",
//   logo: "default_logo",
//   primaryColor: "default_primary_color",
//   secondaryColor: "default_secondary_color",
//   subDomain: "default_sub_domain",
// );
  int subscriptionCount = 0;
  final storage = new FlutterSecureStorage();
  late String errorText;
  bool validate = false;
  bool circular = false;
  String Role = "";
  String Username = "";
  bool isLoading = true;
  final String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';

  Random random = Random();
  String? tag;
  String randomImagePath = '';
  List<String> selecterundomimagepath = [
    'assets/carte-isolee-emplacement_1308-21475.avif',
    'assets/12.avif',
  ];
  @override
  void initState() {
    super.initState();

    _loadData();
    _loadDataTraveller();
    _loadDataplanning();
    _loadDataGuid();
    readRoleFromToken();
    initPlatformState();
    // OneSignal.shared.setAppId('a83993b3-1680-49fa-a371-c5ad4c55849a');
    // OneSignal.shared
    //     .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    //   print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    // });
    // OneSignal.shared.promptUserForPushNotificationPermission();
    // organisation();
  }

  Future<void> logout() async {
    // Delete sensitive data from secure storage
    await storage.deleteAll();

    // Clear data associated with the private screen (if applicable)
    // Example: clear private screen-related variables or state
    // ...

    // Navigate to the login screen
    Get.offNamed('login');
  }
  // void logout() async {
  //   await storage.delete(key: "access_token");
  //   await storage.delete(key: "Role");

  //   // _accessToken = null;
  //   // _userData = null;
  //   Get.off(SplashScreen());
  // }

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
    //   OneSignal.shared
    //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //     OSNotification notification1 = result.notification;

    //     OSNotification notification = result.notification;
    //     OSNotificationAction? action = result.action;

    //     // Access notification properties
    //     String notificationId = notification.notificationId;
    //     String? title = notification.title;
    //     String? body = notification.body;
    //     Map<String, dynamic>? additionalData = notification.additionalData;

    //     // Access action properties
    //     OSNotificationActionType? actionType = action?.type;
    //     String? actionId = action?.actionId;
    //     // Map<String, dynamic>? actionData = action?.additionalData;
    //     print('title $title bodys $body actionType $actionType');
    //     // Perform your desired actions based on the notification and action data
    //     // Navigator.push(context, MaterialPageRoute(builder: (_) => Planingtest()));
    //   });
    //   OneSignal.shared.setNotificationOpenedHandler(
    //     (OSNotificationOpenedResult result) async {
    //       var data = result.notification.additionalData;
    //       // globals.appNavigator.currentState.push(
    //       // MaterialPageRoute(
    //       //   builder: (context) => SecondPage(
    //       //     postId: data['post_id'].toString(),
    //       //   ),
    //       // ),
    //       // );
    //     },
    //   );
  }

  Future<Traveller> _loadDataTraveller() async {
    final userId = await storage.read(key: "id");
    // String? accessToken = await getAccessToken();
    // print('${widget.token} token');
    final travellerdetail =
        await Travelleruserid.fetchData("/api/travellers/UserId/$userId");
    setState(() {
      travller = travellerdetail;

      print(travellerdetail.id);
      isLoading = false;
      _loadDatagroup();
    });
    return travellerdetail;
  }

  Future<TouristGuide> _loadDataGuid() async {
    final userId = await storage.read(key: "id");
    // String? accessToken = await getAccessToken();
    // print('${widget.token} token');
    final toristguiddetail =
        await guidbyuserid.fetchData("/api/tourist-guides/UserIds/$userId");
    setState(() {
      guid = toristguiddetail;

      print(toristguiddetail.id);
      isLoading = false;
      _loadDatagroup();
    });
    return toristguiddetail;
  }

  void _loadData() async {
    setState(() {
      touristGuides = []; // initialize the list to an empty list
    });
    final data = await httpHandler.fetchData("/api/tourist-guides");
    // randomImagePath =
    //     selecterundomimagepath[random.nextInt(selecterundomimagepath.length)];
    // print(randomImagePath);
    if (data == null) {
      // Data is null, navigate to the 'addtouristguid' screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AddTouristGuideScreen()),
      // );
      return; // Stop further execution of the function
    }
    setState(() {
      touristGuides = data.cast<TouristGuide>();
      selectedTouristGuide = data.first as TouristGuide;
      isLoading = false;
    });
  }

  Future<void> sendtags(String? Groupids) async {
    await OneSignal.shared.sendTags({'Guids': '$Groupids'}).then((success) {
      print("Tags created successfully ${guid!.id}");
    }).catchError((error) {
      print("Error creating tags: $error");
    });
    setState(() {
      // OneSignal.shared.deleteTag('$Groupids').then((success) {
      //   print("Old tags deleted successfully");
      // }).catchError((error) {
      //   print("Error deleting old tags: $error");
      // });
      // try {
      // OneSignal.shared.setAppId('ce7f9114-b051-4672-a9c5-0eec08d625e8');
      // OneSignal.shared
      //     .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      //   print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      // });
      // OneSignal.shared.promptUserForPushNotificationPermission();
      OneSignal.shared.sendTags({'Guids': '$Groupids'}).then((success) {
        print("Tags created successfully $Groupids");
      }).catchError((error) {
        print("Error creating tags: $error");
      });
      // } catch (e) {
      //   print('Error initializing OneSignal: $e');
      // }
      // selectedTouristGroup = newValue!;
      // tag = newValue.id!;
      // _loadDataplanning();
      // if (traveller.touristGroupId != null) {
      //   try {
      //     OneSignal.shared.setAppId('ce7f9114-b051-4672-a9c5-0eec08d625e8');
      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      });
      //     OneSignal.shared.promptUserForPushNotificationPermission();
      //     OneSignal.shared.sendTags({
      //       '${traveller.touristGroupId}': '${traveller.touristGroupId}'
      //     }).then((success) {
      //       print("Tags created successfully ${traveller.touristGroupId}");
      //     }).catchError((error) {
      //       print("Error creating tags: $error");
      //     });
      //   } catch (e) {
      //     print('Error initializing OneSignal: $e');
      //   }
      // }
      // print(selectedTouristGroup!.id);
    });
  }

  void _loadDatagroup() async {
    setState(() {
      touristGroup = []; // initialize the list to an empty list
    });
    final data = await httpHandlertorist
        .fetchData("/api/tourist-groups/touristGuideId/${guid?.id}");
    if (data == null) {
      // Data is null, navigate to the 'addtouristguid' screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AddTouristGuideScreen()),
      // );
      return; // Stop further execution of the function
    }
    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first as TouristGroup;
      _touristGroupProvider.updateSelectedTouristGroup(data.first);
      isLoading = false;
    });
  }
// void _loadDatagroup() async {
//     try {
//       // Fetch data using your httpHandlertorist's fetchData method
//       final data = await httpHandlertorist
//           .fetchData("/api/tourist-groups/touristGuideId/${guid?.id}");

//       if (data == null) {
//         // Data is null, handle this scenario
//         return;
//       }

//       // Update the tourist groups using the provider
//       _touristGroupProvider.updateSelectedTouristGroup(data.first);
//     } catch (error) {
//       // Handle any errors that occur during data fetching
//       print('Error loading tourist group data: $error');
//     }
//   }
  void _loadDataplanning() async {
    setState(() {
      planning = []; // initialize the list to an empty list
    });

    final data = await httpHandlerPlanning.fetchData("/api/plannings");

// /touristGroupId/${selectedTouristGroup!.id}");

    setState(() {
      print('$data data1');
      planning = data.cast<PlanningMainModel>();

      if (data.isNotEmpty) {
        print('$data data');
        selectedPlanning = data.first as PlanningMainModel;
      } else {
        print('$data data');
        selectedPlanning = null;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AddPlanningScreen()),
        // );
      }
    });
  }

  Future<void> sendtag() async {}
  void readRoleFromToken() async {
    String? token = await storage.read(key: "access_token");
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
    String role = decodedToken['role'];
    String user = decodedToken['username'];
    setState(() {
      Role = role;
      Username = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final touristGroupProvider = Provider.of<TouristGroupProvider>(context);

    final selectedPlanningProvider = Provider.of<TouristGroupProvider>(context);
    final selectedp = selectedPlanningProvider.selectedPlanning;
    final selectedg =
        selectedPlanningProvider.selectedTouristGroup ?? selectedTouristGroup;

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
                        SizedBox(
                          height: Get.width * 0.7,
                        ),
                        Text('session Tim out.... ',
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
                            textStyle: TextStyle(
                                fontSize: 16), // Change the text style
                            padding: EdgeInsets.symmetric(
                                horizontal: 16), // Adjust the padding
                            minimumSize: Size(120,
                                40), // Set a minimum width and height for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                          ),
                          onPressed: () async {
                            // await storage.delete(key: "access_token");
                            // await storage.delete(key: "Role");
                            logout();
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
      if (Role == "Administrator") {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: planning!.isEmpty
                      ? const <Widget>[]
                      : [
                          Image.network(
                            'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                            width: 330, // Adjust the width as needed
                            height: 330, // Adjust the height as needed
                          ),
                          const SizedBox(height: 70),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 207, 207, 206),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Get.to(
                                  PlanningScreen(selectedPlanning!.id, guid));
                              sendtags(guid!.id);
                            },
                            child: SizedBox(
                              width: Get.width * 0.8,
                              height: Get.height * 0.06,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.door_back_door_outlined,
                                    color: Color.fromARGB(255, 26, 24, 25),
                                    size: 24,
                                  ),
                                  Text(
                                    'Let\'s Go Travel!',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 42, 9, 60),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        );
        //     ],
        //   ),
        // );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: Get.width * 0.4,
                top: Get.height * 0.08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${guid?.id ?? " Finish your profile"}"),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Color.fromARGB(0, 3, 3, 169),
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                        print("hi");
                      },
                      child: SvgPicture.asset(
                        'assets/Frame.svg',
                        height: 80,
                        width: 80,
                        // color: Color.fromARGB(255, 49, 8, 236),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(244, 181, 180, 179),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: touristGroup!.isEmpty
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(Color.fromARGB(184, 209, 17,
                                        17)), // Set the desired background color
                              ),
                              onPressed: () {
                                // Handle button press, navigate to desired screen or perform any action
                                // Get.to(AddTouristGroupScreen());
                              },
                              child: Text('you are not effect  group'),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                DropdownButton<TouristGroup>(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  dropdownColor:
                                      Color.fromARGB(255, 210, 151, 3),
                                  iconEnabledColor:
                                      Color.fromARGB(161, 0, 0, 0),
                                  iconDisabledColor:
                                      Color.fromARGB(255, 158, 158, 158),
                                  value: selectedTouristGroup,
                                  items: touristGroup!.map((touristGroup) {
                                    return DropdownMenuItem<TouristGroup>(
                                        value: touristGroup,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.group,
                                              size:
                                                  20, // Set the desired size of the icon
                                            ),
                                            SizedBox(
                                                width: 4), // Adjust spacing
                                            Container(
                                              width:
                                                  100, // Adjust this width as needed

                                              child: Text(
                                                // touristGroup.name!.length > 5
                                                // ? '${touristGroup.name!.substring(0, 5)}...' // Truncate the content if it's longer than 20 characters
                                                // :
                                                touristGroup.name ??
                                                    'i known grop',
                                                // p.name ?? 'i known Plannig',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,

                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 88, 19, 2)),
                                              ),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                  onChanged: (TouristGroup? newValue) {
                                    setState(() {
                                      OneSignal.shared
                                          .deleteTag(
                                              '${selectedTouristGroup?.id}')
                                          .then((success) {
                                        print("Old tags deleted successfully");
                                      }).catchError((error) {
                                        print(
                                            "Error deleting old tags: $error");
                                      });

                                      selectedTouristGroup = newValue!;
                                      tag = newValue.id!;
                                      _loadDataplanning();
                                      if (selectedTouristGroup?.id != null) {
                                        try {
                                          OneSignal.shared.setAppId(
                                              'ce7f9114-b051-4672-a9c5-0eec08d625e8');
                                          OneSignal.shared
                                              .setSubscriptionObserver(
                                                  (OSSubscriptionStateChanges
                                                      changes) {
                                            print(
                                                "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
                                          });
                                          OneSignal.shared
                                              .promptUserForPushNotificationPermission();
                                          OneSignal.shared.sendTags({
                                            '${selectedTouristGroup?.id}':
                                                '${selectedTouristGroup?.id}'
                                          }).then((success) {
                                            print("Tags created successfully");
                                          }).catchError((error) {
                                            print(
                                                "Error creating tags: $error");
                                          });
                                        } catch (e) {
                                          print(
                                              'Error initializing OneSignal: $e');
                                        }
                                      }
                                      print(selectedTouristGroup!.id);
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .all<Color>(Color.fromARGB(184, 209, 17,
                                            17)), // Set the desired background color
                                  ),
                                  onPressed: () {
                                    // Handle button press, navigate to desired screen or perform any action
                                    // Get.to(AddTouristGroupScreen());
                                  },
                                  child: Text('new Goup'),
                                ),
                                FutureBuilder<int>(
                                  future: count.fetchInlineCount(
                                    "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}",
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while fetching the inline count
                                      return CircularProgressIndicator(
                                          strokeWidth: 1.0);
                                    }
                                    if (snapshot.hasError) {
                                      // Handle the error if the inline count couldn't be fetched
                                      return Text("Error");
                                    }
                                    final inlineCount = snapshot.data ?? 0;
                                    return Text(
                                      " $inlineCount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(226, 207, 71, 3),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: planning!.isEmpty
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(Color.fromARGB(184, 209, 17,
                                        17)), // Set the desired background color
                              ),
                              onPressed: () {
                                // Get.to(AddPlanningScreen());
                              },
                              child: Text('Plannig'),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width:
                                      Get.width * 0.40, // Set the desired width
                                  height: 50,
                                  child: DropdownButton<PlanningMainModel>(
                                    dropdownColor:
                                        Color.fromARGB(255, 210, 151, 3),
                                    iconEnabledColor:
                                        Color.fromARGB(161, 0, 0, 0),
                                    iconDisabledColor:
                                        Color.fromARGB(255, 158, 158, 158),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    value: selectedPlanning,
                                    items: planning!.map((p) {
                                      return DropdownMenuItem<
                                          PlanningMainModel>(
                                        value: p,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 2),
                                            Container(
                                              width: Get.width *
                                                  0.28, // Adjust this width as needed
                                              child: Text(
                                                p.name ?? 'i known Planning',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 83, 6, 3),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (PlanningMainModel? newValue) {
                                      setState(() {
                                        selectedPlanning = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .all<Color>(Color.fromARGB(184, 209, 17,
                                            17)), // Set the desired background color
                                  ),
                                  onPressed: () {
                                    // Get.to(AddPlanningScreen());
                                  },
                                  child: Text('Plannig'),
                                )
                              ],
                            ),
                    ),
                    planning!.isEmpty
                        ? Column(
                            children: const [
                              SizedBox(height: 50),
                              Text(
                                  'Please Create tourist guid and plannig first',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 60),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(234, 233, 233, 236),
                                      Color.fromARGB(255, 189, 4, 4),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromARGB(0, 236, 230, 230),
                                    ),
                                  ),
                                  onPressed: () {
                                    //   Get.to(Planingtest(
                                    //   touristGroup: selectedTouristGroup,
                                    //   planning: selectedPlanning,
                                    // ));
                                    // Get.to(PlanningScreen(
                                    //     selectedPlanning!.id, guid));
                                    // Get.to(PushNotificationUpdateScreen());
                                  },
                                  child: SizedBox(
                                    width: Get.width * 0.5,
                                    height: Get.height * 0.06,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.sensor_door_rounded,
                                          color: Color.fromARGB(227, 172, 2, 2),
                                        ), // Add the planning icon here
                                        // Add some spacing between the icon and text
                                        Text('Go To  Plannings',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 235, 232, 226),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.5,
                                height: Get.height * 0.06,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(0, 236, 230, 230),
                                  ),
                                ),
                                onPressed: () {
                                  //   Get.to(Planingtest(
                                  //   touristGroup: selectedTouristGroup,
                                  //   planning: selectedPlanning,
                                  // ));
                                  // Get.to(TravellerCalendarPage(
                                  //   planning: selectedPlanning,
                                  //   group: travller.touristGroupId,
                                  // ));
                                },
                                child: SizedBox(
                                  width: Get.width * 0.5,
                                  height: Get.height * 0.06,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.sensor_door_rounded,
                                        color: Color.fromARGB(227, 172, 2, 2),
                                      ), // Add the planning icon here
                                      // Add some spacing between the icon and text
                                      Text('Go To Me Transport ',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 235, 232, 226),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                    const SizedBox(height: 50),
                    // ClockWidget(),
                    // selectedTouristGuide?.agency?.mobile == null
                    //     ? Container()
                    //     : GestureDetector(
                    //         onTap: () {
                    //           launch(
                    //               'tel:${selectedTouristGuide?.agency?.mobile ?? ""}');
                    //         },
                    //         child: Text(
                    //           'Call   : ${selectedTouristGuide?.agency?.mobile ?? "h"}',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 40,
                    //             color: Color.fromARGB(255, 246, 242, 239),
                    //             decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //       ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    }
  }

  Widget bottomSheet() {
    return
//  Container(padding:EdgeInsets.all(15),
//       width: MediaQuery.of(context).size.width,
//       child:
        Card(
      margin: EdgeInsets.all(14),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(235, 79, 2, 2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(210, 55, 4, 221),
              Color.fromARGB(255, 189, 4, 4)
            ],
          ),
        ),
        height: Get.height * 0.25,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  'assets/Frame.svg',
                  height: 50,
                  width: 80,
                  // color: Color.fromARGB(255, 49, 8, 236),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zen",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 243, 235, 2)),
                    ),
                    Text(
                      "Ify",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(233, 241, 239, 245)),
                    ),
                    Text(
                      " Trip",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 193, 2, 187)),
                    ),
                  ],
                ),
                Text(
                  "For more Details ...",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(233, 152, 108, 238)),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      selectedTouristGuide?.agency?.mobile == null
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                launch(
                                    'tel:${selectedTouristGuide?.agency?.mobile ?? ""}');
                              },
                              child: Row(
                                children: [
                                  TextButton.icon(
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      launch(
                                          'tel:${selectedTouristGuide?.agency?.mobile ?? ""}');
                                    },
                                    label: Text(
                                        'Call   : ${selectedTouristGuide?.agency?.mobile ?? "h"}',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  // Text(

                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 10,
                                  //     color: Color.fromARGB(255, 3, 9, 0),
                                  //     decoration: TextDecoration.underline,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),

                      // TextButton.icon(
                      //   icon: Icon(Icons.phone),
                      //   onPressed: () {

                      //   },
                      //   label: Text("Gallery"),
                      // ),
                    ]),
                selectedTouristGuide?.agency?.website != null
                    ? TextButton.icon(
                        icon: Icon(Icons.assistant, color: Colors.white),
                        onPressed: () {
                          launch(selectedTouristGuide!.agency!.website!);
                        },
                        label: Text(
                          "Web Site",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
    // );
  }
}
