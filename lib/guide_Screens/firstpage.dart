import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zenify_trip/NetworkHandler.dart';
import 'package:zenify_trip/guide_Screens/calendar/menu.dart';
import 'package:zenify_trip/main.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../modele/HttpPlaning.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/httpToristGroup.dart';
import '../../modele/activitsmodel/httpToristguid.dart';
import '../../modele/httpTouristguidByid.dart';
import '../../modele/httpTravellerbyid.dart';
import '../../modele/planningmainModel.dart';
import '../../modele/traveller/TravellerModel.dart';

class PlaningSecreen extends StatefulWidget {
  const PlaningSecreen({super.key});

  @override
  State<PlaningSecreen> createState() => _PlaningSecreenState();
}

class _PlaningSecreenState extends State<PlaningSecreen> {
  TextEditingController groupkeycontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    // initPlatformState();
  }

  Future<void> logout() async {
    // Delete sensitive data from secure storage
    await storage.deleteAll();

    void logout() async {
      await storage.delete(key: "access_token");
      await storage.delete(key: "Role");
      Get.toNamed('login');
      Get.off(SplashScreen());
    }
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
      selectedTouristGuide = data.first;
      isLoading = false;
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
    if (isLoading) {
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
                      SizedBox(
                        height: Get.width * 0.7,
                      ),
                      const Text('session Tim out.... ',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Color.fromARGB(255, 90, 3, 203))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // Change the text color
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
                        child: const Text('Logout'),
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
      if (Role == "Administrator") {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    planning!.isEmpty
                        ? const Column()
                        : Column(
                            children: [
                              const SizedBox(height: 30),
                              Image.network(
                                'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                                width:
                                    290, // Ajustez la largeur selon vos besoins
                                height:
                                    290, // Ajustez la hauteur selon vos besoins
                              ),
                              const SizedBox(height: 50),
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
                                        color: Color.fromARGB(225, 26, 24, 25),
                                        size: 22,
                                      ),
                                      Text(
                                        'Lest´s Go Travel !',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 235, 232, 226),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      }
    }
  }

  Widget bottomSheet() {
    return Card(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
