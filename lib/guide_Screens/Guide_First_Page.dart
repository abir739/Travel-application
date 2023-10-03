import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenify_trip/NetworkHandler.dart';
import 'package:zenify_trip/guide_Screens/calendar/Guide_Calendar.dart';
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
import '../Secreens/TouristGroupProvider.dart';

class PlaningSecreen extends StatefulWidget {
  const PlaningSecreen({super.key});

  @override
  State<PlaningSecreen> createState() => _PlaningSecreenState();
}

class _PlaningSecreenState extends State<PlaningSecreen> {
  TextEditingController groupkeycontroller = TextEditingController();
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
  final httpHandlertoristguid = HTTPHandlerhttpToristguid();
  final httpHandlertorist = HTTPHandlerhttpGroup();
  final httpHandlerPlanning = HTTPHandlerplaning();
  final count = HTTPHandlerCount();
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? touristGroup;
  List<PlanningMainModel>? planning;
  TouristGuide? selectedTouristGuide = TouristGuide();
  TouristGroup? selectedTouristGroup = TouristGroup();
  PlanningMainModel? selectedPlanning = PlanningMainModel();
  final TouristGroupProvider _touristGroupProvider = TouristGroupProvider();
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
  }

  Future<void> logout() async {
    // Delete sensitive data from secure storage
    await storage.deleteAll();
    Get.offNamed('login');
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      oneSignalAppId,
    );

  }

  Future<Traveller> _loadDataTraveller() async {
    final userId = await storage.read(key: "id");
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
    if (data == null) {
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
      OneSignal.shared.sendTags({'Guids': '$Groupids'}).then((success) {
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

  void _loadDatagroup() async {
    setState(() {
      touristGroup = []; // initialize the list to an empty list
    });
    final data = await httpHandlertorist
        .fetchData("/api/tourist-groups/touristGuideId/${guid?.id}");
    if (data == null) {
      return; // Stop further execution of the function
    }
    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first as TouristGroup;
      _touristGroupProvider.updateSelectedTouristGroup(data.first);
      isLoading = false;
    });
  }

  void _loadDataplanning() async {
    setState(() {
      planning = []; // initialize the list to an empty list
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
    final selectedPlanningProvider = Provider.of<TouristGroupProvider>(context);
    final selectedp = selectedPlanningProvider.selectedPlanning;
    final selectedg =
        selectedPlanningProvider.selectedTouristGroup ?? selectedTouristGroup;

    if (isLoading) {
      return Scaffold(
        body: Container(
          child: Center(
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator or any other widget while waiting
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: const Color.fromARGB(255, 219, 10, 10),
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
                          child: const Text('Logout'),
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
                              Get.to(PlanningScreen(guid));
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
                          backgroundColor: const Color.fromARGB(0, 3, 3, 169),
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                        print("hi");
                      },
                      child: SvgPicture.asset(
                        'assets/Frame.svg',
                        height: 80,
                        width: 80,
                      
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(244, 181, 180, 179),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: touristGroup!.isEmpty
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(const Color.fromARGB(184, 209, 17,
                                        17)), // Set the desired background color
                              ),
                              onPressed: () {
                                
                              },
                              child: const Text('you are not effect  group'),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                DropdownButton<TouristGroup>(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  dropdownColor:
                                      const Color.fromARGB(255, 210, 151, 3),
                                  iconEnabledColor:
                                      const Color.fromARGB(161, 0, 0, 0),
                                  iconDisabledColor:
                                      const Color.fromARGB(255, 158, 158, 158),
                                  value: selectedTouristGroup,
                                  items: touristGroup!.map((touristGroup) {
                                    return DropdownMenuItem<TouristGroup>(
                                        value: touristGroup,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.group,
                                              size:
                                                  20, // Set the desired size of the icon
                                            ),
                                            const SizedBox(
                                                width: 4), // Adjust spacing
                                            Container(
                                              width:
                                                  100, // Adjust this width as needed

                                              child: Text(
                                                
                                                touristGroup.name ??
                                                    'i known grop',
                                                
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,

                                                style: const TextStyle(
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
                                        .all<Color>(const Color.fromARGB(184, 209, 17,
                                            17)), // Set the desired background color
                                  ),
                                  onPressed: () {
                                  
                                  },
                                  child: const Text('new Goup'),
                                ),
                                FutureBuilder<int>(
                                  future: count.fetchInlineCount(
                                    "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}",
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                 
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
                        color: Color.fromARGB(226, 207, 71, 3),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(left: 40, right: 40),
                      child: planning!.isEmpty
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(const Color.fromARGB(184, 209, 17,
                                        17)), // Set the desired background color
                              ),
                              onPressed: () {
                                // Get.to(AddPlanningScreen());
                              },
                              child: const Text('Plannig'),
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
                                        const Color.fromARGB(255, 210, 151, 3),
                                    iconEnabledColor:
                                        const Color.fromARGB(161, 0, 0, 0),
                                    iconDisabledColor:
                                        const Color.fromARGB(255, 158, 158, 158),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
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
                                                style: const TextStyle(
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
                                        .all<Color>(const Color.fromARGB(184, 209, 17,
                                            17)), // Set the desired background color
                                  ),
                                  onPressed: () {
                                    // Get.to(AddPlanningScreen());
                                  },
                                  child: const Text('Plannig'),
                                )
                              ],
                            ),
                    ),
                    planning!.isEmpty
                        ? const Column(
                            children: [
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
                                decoration: const BoxDecoration(
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
                                      const Color.fromARGB(0, 236, 230, 230),
                                    ),
                                  ),
                                  onPressed: () {
                                  
                                  },
                                  child: SizedBox(
                                    width: Get.width * 0.5,
                                    height: Get.height * 0.06,
                                    child: const Row(
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
                                    const Color.fromARGB(0, 236, 230, 230),
                                  ),
                                ),
                                onPressed: () {
                               
                                },
                                child: SizedBox(
                                  width: Get.width * 0.5,
                                  height: Get.height * 0.06,
                                  child: const Row(
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
        Card(
      margin: const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(235, 79, 2, 2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: const BoxDecoration(
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
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  'assets/Frame.svg',
                  height: 50,
                  width: 80,
                  // color: Color.fromARGB(255, 49, 8, 236),
                ),
                const Row(
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
                const Text(
                  "For more Details ...",
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(233, 152, 108, 238)),
                ),
              ],
            ),
            const SizedBox(
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
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      launch(
                                          'tel:${selectedTouristGuide?.agency?.mobile ?? ""}');
                                    },
                                    label: Text(
                                        'Call   : ${selectedTouristGuide?.agency?.mobile ?? "h"}',
                                        style: const TextStyle(color: Colors.white)),
                                  ),
                                  
                                ],
                              ),
                            ),

                     
                    ]),
                selectedTouristGuide?.agency?.website != null
                    ? TextButton.icon(
                        icon: const Icon(Icons.assistant, color: Colors.white),
                        onPressed: () {
                          launch(selectedTouristGuide!.agency!.website!);
                        },
                        label: const Text(
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
