import 'dart:convert';
import 'dart:math';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:zenify_trip/NetworkHandler.dart';

import 'package:zenify_trip/Secreens/TouristGroupProvider.dart';
import 'package:zenify_trip/Secreens/Upload_Files/FilePickerUploader.dart';

import 'package:zenify_trip/modele/HttpUserHandler.dart';
import 'package:zenify_trip/modele/activitsmodel/usersmodel.dart';

import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:zenify_trip/routes/SettingsProvider.dart';
import 'package:zenify_trip/services/GuideProvider.dart';
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/widget/button_widget.dart';
import 'package:zenify_trip/widget/numbers_widget.dart';
import 'package:zenify_trip/widget/profile_widget.dart';

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

class PlanningSecreen extends StatefulWidget {
  const PlanningSecreen({super.key});

  @override
  State<PlanningSecreen> createState() => _PlanningSecreenState();
}

class _PlanningSecreenState extends State<PlanningSecreen> {
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
  FilePickerUploader uploader = FilePickerUploader();
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? touristGroup;
  List<PlanningMainModel>? planning;
  TouristGuide? selectedTouristGuide = TouristGuide();
  TouristGroup? selectedTouristGroup = TouristGroup();
  final httpUserHandler = HttpUserHandler();
  PlanningMainModel? selectedPlanning = PlanningMainModel();
  final TouristGroupProvider _touristGroupProvider = TouristGroupProvider();
  User? user = User();
  int subscriptionCount = 0;
  final storage = new FlutterSecureStorage();
  late String errorText;
  bool validate = false;
  bool circular = false;
  String Role = "";
  String Username = "";
  bool isLoading = true;
  final bool isEdit = true;
  final String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';
  Alignment _alignment = Alignment.center;
  Alignment _alignment0 = Alignment.center;
  Random random = Random();
  String? tag;
  String? guidid;
  String randomImagePath = '';
  List<String> selecterundomimagepath = [
    'assets/carte-isolee-emplacement_1308-21475.avif',
    'assets/12.avif',
  ];
  @override
  void initState() {
    super.initState();
    readRoleFromToken();
    initPlatformState();
    _initializeTravelerData();
  }

  Future<void> _onRefresh() async {
    _initializeTravelerData();
  }

  void _onImageTap() {
    print('Image tapped'); // Add this line for debugging
    setState(() {
      _alignment = (_alignment == Alignment.center)
          ? Alignment.centerLeft
          : (_alignment == Alignment.centerLeft)
              ? Alignment.centerRight
              : (_alignment == Alignment.centerRight)
                  ? Alignment.center
                  : Alignment.center;
    });
  }

  void _loadUser(String? userid) async {
    final userId = await storage.read(key: "id");
    try {
      user = await httpUserHandler.fetchUser('/api/users/$userId');

      setState(() {});
// if(user.gender==null){
//     Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => CreatProfile()),
//                   );
// }
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  bool _isDataLoaded = false; // Track if data is loaded

  Future<void> loadData() async {
    // Perform your asynchronous operation here (e.g., navigate)
    // await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()));
    // After the operation is done, set the flag to true
    setState(() {
      _isDataLoaded = true;
    });
  }

  Future<void> _initializeTravelerData() async {
    final GuideProvider = Provider.of<guidProvider>(context, listen: false);

    try {
      final result = await GuideProvider.loadDataGuidDetail();
      _loadUser(result?.userId);

      setState(() {
        guid = result;
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }
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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          user?.picture == null
              ? AnimatedAlign(
                  alignment:
                      settingsProvider.isAnimated ? _alignment : _alignment0,
                  duration: settingsProvider.isAnimated
                      ? Duration(microseconds: 1)
                      : Duration(seconds: 5),
                  child: ProfileWidget(
                    imagePath:
                        'https://4kwallpapers.com/images/walls/thumbs_2t/2167.jpg',
                    onClicked: () async {
                      _onImageTap();
                      String? newData = await uploader.pickAndUploadFile(
                        dynamicPath:
                            'traveller', // Replace with your dynamic path
                        id: '${user?.id}', // Replace with your id
                        object: 'api/users', // Replace with your object
                        field: 'picture', // Replace with your field
                      ); // Call your async operation when the button is clicked
                    },
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: Get.height * 0.12),
                    AnimatedAlign(
                        alignment: settingsProvider.isAnimated
                            ? _alignment
                            : _alignment0,
                        duration: settingsProvider.isAnimated
                            ? Duration(microseconds: 1)
                            : Duration(microseconds: 5),
                        child: Stack(
                          children: [
                            Positioned(
                              child: ProfileWidget(
                                imagePath:
                                    '${baseUrls}/assets/uploads/traveller/${user?.picture}',
                                onClicked: () async {
                                  _onImageTap();
                                  // String? newData = await uploader.pickAndUploadFile(
                                  //   dynamicPath:
                                  //       'traveller', // Replace with your dynamic path
                                  //   id: '${user?.id}', // Replace with your id
                                  //   object: 'api/users', // Replace with your object
                                  //   field: 'picture', // Replace with your field
                                  // ); //
                                  // if (newData != null) {
                                  //   // You can use newData here
                                  //   print("Received data from FileUploadScreen: $newData");
                                  //   setState(() {
                                  //     _onRefresh();
                                  //     //
                                  //   });
                                  // } else {
                                  //   // Handle the case where newData is null
                                  //   print("No data received from FileUploadScreen");
                                  // }
                                },
                              ),
                            ),
                            Positioned(
                              top: Get.height * 0.8,
                              child: GestureDetector(
                                onTap: () async {
                                  String? newData =
                                      await uploader.pickAndUploadFile(
                                    dynamicPath:
                                        'traveller', // Replace with your dynamic path
                                    id: '${user?.id}', // Replace with your id
                                    object:
                                        'api/users', // Replace with your object
                                    field: 'picture', // Replace with your field
                                  ); //
                                  if (newData != null) {
                                    // You can use newData here
                                    print(
                                        "Received data from FileUploadScreen: $newData");
                                    setState(() {
                                      _onRefresh();
                                      _onImageTap();
                                    });
                                  } else {
                                    // Handle the case where newData is null
                                    print(
                                        "No data received from FileUploadScreen");
                                  }
                                },
                                child: buildEditIcon(Colors.blue),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
          const SizedBox(height: 24),
          buildName(guid),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          // buildAbout(guid),
        ],
      ),
    );
  }

  Widget buildName(TouristGuide? guid) => Column(
        children: [
          Text(
            guid?.name ?? "N/A",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? "N/A",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() {
    return ButtonWidget(
      text: 'Upgrade To PRO',
      onClicked: () {},
      color: const Color(0xFF3A3557),
    );
  }

  // Widget buildAbout(TouristGuide? guid) => Container(
  //       padding: EdgeInsets.symmetric(horizontal: 48),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'About',
  //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             guid?.fullName ?? "N/A",
  //             style: TextStyle(fontSize: 16, height: 1.4),
  //           ),
  //         ],
  //       ),
  //     );
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

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: color,
          all: 5,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
