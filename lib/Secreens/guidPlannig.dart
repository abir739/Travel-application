
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenify_trip/NetworkHandler.dart';
import 'package:zenify_trip/Secreens/AddPlanningScreen.dart';
import 'package:zenify_trip/guide_Screens/calendar/calendar_transferts.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import '../modele/HttpPlaning.dart';
import '../modele/TouristGuide.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/httpToristGroup.dart';
import '../modele/activitsmodel/httpToristguid.dart';
import '../modele/planningmainModel.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'AddToristGroupScreen.dart';


class PlaningSecreen extends StatefulWidget {
  const PlaningSecreen({super.key});

  @override
  State<PlaningSecreen> createState() => _PlaningSecreenState();
}

class _PlaningSecreenState extends State<PlaningSecreen> {
  TextEditingController groupkeycontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final _globalkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  int selectedRadio = 0;
  TextEditingController forgetEmailController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  final httpHandler = HTTPHandlerhttpToristguid();
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
    _loadDatagroup();
    _loadDataplanning();
    readRoleFromToken();
    initPlatformState();
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
      // Perform your desired actions based on the notification and action data
      // Navigator.push(context, MaterialPageRoute(builder: (_) => Planingtest()));
    });
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) async {
        var data = result.notification.additionalData;
      },
    );
  }

  void _loadData() async {
    setState(() {
      touristGuides = [];
    });
    final data = await httpHandler.fetchData("/api/tourist-guides");
    if (data == null) {
      return;
    }
    setState(() {
      touristGuides = data.cast<TouristGuide>();
      selectedTouristGuide = data.first as TouristGuide;
      isLoading = false;
    });
  }

  void _loadDatagroup() async {
    setState(() {
      touristGroup = [];
    });
    final data = await httpHandlertorist.fetchData(
        "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}");
    if (data == null) {
      return;
    }
    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first as TouristGroup;
      isLoading = false;
    });
  }

  void _loadDataplanning() async {
    setState(() {
      planning = [];
    });

    final data = await httpHandlerPlanning.fetchData("/api/plannings");

    setState(() {
      print('$data data1');
      planning = data.cast<PlanningMainModel>();

      if (data.isNotEmpty) {
        print('$data data');
        selectedPlanning = data.first as PlanningMainModel;
      } else {
        print('$data data');
        selectedPlanning = null;
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
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 5)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator or any other widget while waiting
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 219, 10, 10),
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 24, 10, 221)),
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
                          textStyle:
                              TextStyle(fontSize: 16), // Change the text style
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
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Corrected placement of SizedBox
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(244, 19, 123, 184),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: touristGuides!.isEmpty
                        ? ElevatedButton(
                            onPressed: () {},
                            child: const Text('Choose the  tourist guide:'),
                          )
                        : Row(
                            children: [
                              const SizedBox(height: 8),
                              DropdownButton<TouristGuide>(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                dropdownColor:
                                    Color.fromARGB(244, 19, 123, 184),
                                iconEnabledColor:
                                    const Color.fromARGB(161, 0, 0, 0),
                                iconDisabledColor:
                                    Color.fromARGB(244, 19, 123, 184),
                                value: selectedTouristGuide,
                                items: touristGuides!.map((touristGuide) {
                                  return DropdownMenuItem<TouristGuide>(
                                    value: touristGuide,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.person,
                                          size:
                                              20, // Set the desired size of the icon
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ), // Add some spacing between the icon and text
                                        Text(
                                          touristGuide.name!.length > 5
                                              ? '${touristGuide.name!.substring(0, 5)}...' // Truncate the content if it's longer than 20 characters
                                              : touristGuide.name ?? 'h',
                                          // p.name ?? 'i known Plannig',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,

                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 42, 1, 44)),
                                        ),
                                        const SizedBox(width: 24),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (TouristGuide? newValue) {
                                  selectedTouristGuide = newValue!;

                                  _loadDatagroup();
                                },
                              ),
                              const SizedBox(
                                width: 170,
                              ),
                              FutureBuilder<int>(
                                future: count.fetchInlineCount(
                                  "/api/tourist-guides",
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while fetching the inline count
                                    return const CircularProgressIndicator(
                                        strokeWidth: 1.0);
                                  }
                                  if (snapshot.hasError) {
                                    // Handle the error if the inline count couldn't be fetched
                                    return const Text("Error");
                                  }
                                  final inlineCount = snapshot.data ?? 0;
                                  return Text(
                                    " $inlineCount",
                                    style: const TextStyle(
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(244, 19, 123, 184),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: touristGroup!.isEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(244, 78, 3, 73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
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
                                    const BorderRadius.all(Radius.circular(20)),
                                dropdownColor:
                                    Color.fromARGB(244, 19, 123, 184),
                                iconEnabledColor:
                                    const Color.fromARGB(161, 0, 0, 0),
                                iconDisabledColor:
                                    Color.fromARGB(244, 19, 123, 184),
                                value: selectedTouristGroup,
                                items: touristGroup!.map((touristGroup) {
                                  return DropdownMenuItem<TouristGroup>(
                                      value: touristGroup,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.group,
                                            size:
                                                20, // Set the desired size of the icon
                                          ),
                                          const SizedBox(
                                              width:
                                                  12), // Adjust this width as needed

                                          Text(
                                            // touristGroup.name!.length > 5
                                            // ? '${touristGroup.name!.substring(0, 5)}...' // Truncate the content if it's longer than 20 characters
                                            // :
                                            touristGroup.name ?? 'i known grop',
                                            // p.name ?? 'i known Plannig',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,

                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 42, 1, 44)),
                                          ),
                                          const SizedBox(width: 10),
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
                                      print("Error deleting old tags: $error");
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
                                          print("Error creating tags: $error");
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
                              const SizedBox(
                                width: 28,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(244, 78, 3, 73),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  // Handle button press, navigate to desired screen or perform any action
                                  Get.to(const AddTouristGroupScreen());
                                },
                                child: const Text('new Group'),
                              ),
                              FutureBuilder<int>(
                                future: count.fetchInlineCount(
                                  "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}",
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while fetching the inline count
                                    return const CircularProgressIndicator(
                                        strokeWidth: 1.0);
                                  }
                                  if (snapshot.hasError) {
                                    // Handle the error if the inline count couldn't be fetched
                                    return const Text("Error");
                                  }
                                  final inlineCount = snapshot.data ?? 0;
                                  return Text(
                                    " $inlineCount",
                                    style: const TextStyle(
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(244, 19, 123, 184),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: planning!.isEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(244, 78, 3, 73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Get.to(const AddPlanningScreen());
                            },
                            child: const Text('new Plannig'),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width:
                                    Get.width * 0.56, // Set the desired width
                                height: 60,
                                child: DropdownButton<PlanningMainModel>(
                                  dropdownColor:
                                      const Color.fromARGB(244, 19, 123, 184),
                                  iconEnabledColor:
                                      const Color.fromARGB(161, 0, 0, 0),
                                  iconDisabledColor:
                                      const Color.fromARGB(244, 19, 123, 184),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  value: selectedPlanning,
                                  items: planning!.map((p) {
                                    return DropdownMenuItem<PlanningMainModel>(
                                      value: p,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.calendar_today,
                                            size:
                                                20, // Set the desired size of the icon
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            p.name ?? 'i known Planning',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 42, 1, 44)),
                                          ),
                                          const SizedBox(width: 20),
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
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(244, 78, 3, 73),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  // Get.to(AddPlanningScreen());
                                },
                                child: const Text(' new Plannig'),
                              )
                            ],
                          ),
                  ),
                  planning!.isEmpty
                      ? const Column(
                          children: [
                            SizedBox(height: 50),
                            Text('Please Create tourist guid and plannig first',
                                style: TextStyle(fontSize: 20)),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 90),
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(255, 207, 207, 206),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  //   Get.to(Planingtest(
                                  //   touristGroup: selectedTouristGroup,
                                  //   planning: selectedPlanning,
                                  // ));
                                  // Get.to(MyCalendarPage(
                                  //   planning: selectedPlanning,

                                  // Get.to(PlanningScreen(selectedPlanning!.id,
                                  //     selectedTouristGuide));

                                  //  Get.to(CalendarPage());

                                  Get.to(PlanningScreen(selectedPlanning!.id,
                                      selectedTouristGuide));
                                },
                                child: SizedBox(
                                  width: Get.width * 0.8,
                                  height: Get.height * 0.06,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.door_back_door_outlined,
                                        color: Color.fromARGB(225, 26, 24, 25),
                                      ),
                                      Text(
                                          'Go To ${selectedPlanning?.name ?? 'Planning'}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 235, 232, 226),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
        //  bottomNavigationBar: AppBottomNavigationBar(),
      );
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
