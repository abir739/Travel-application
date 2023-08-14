import 'dart:async';
import 'dart:convert';
// import 'package:badges/badges.dart' as badges;
import 'dart:math';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter_animated_icons/icons8.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location;
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
// import 'package:zenify_trip_mobile/Secreen/PushNotificationScreen.dart';
// import 'package:zenify_trip_mobile/modele/activitsmodel/activitesmodel.dart';
// import 'package:location/location.dart';
// import '../Secreen/services/FileUploadScreen.dart';
// import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../constent.dart';
import '../modele/HttpUserHandler.dart';
import '../modele/accommodationsModel/accommodationModel.dart';
import '../modele/activitsmodel/activitesmodel.dart';
import '../modele/activitsmodel/activityTempModel.dart';
import '../modele/activitsmodel/httpActivitesTempid.dart';
import '../modele/activitsmodel/usersmodel.dart';

import '../modele/touristGroup.dart';
import '../modele/transportmodel/transportModel.dart';

import 'Profile/CreatProfile.dart';
import 'Profile/MainProfile.dart';
import 'Profile/UpdateActivityDetailDialog.dart';

import '../modele/HttpPlaning.dart';
import '../modele/PlanningHandler.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/listactivitey.dart';
import '../modele/item.dart';
import '../modele/listPlannig.dart';
import '../modele/planning_model.dart';
import '../modele/planningmainModel.dart';
import '../modele/plannings.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'GenerateQRPage.dart';
// import 'Notivificationactivity.dart';
// import 'constants.dart';
// import 'login_signup.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Planingtest extends StatefulWidget {
  final TouristGroup? touristGroup;
  final PlanningMainModel? planning;
  const Planingtest({super.key, this.touristGroup, this.planning});

  @override
  State<Planingtest> createState() => _PlaningtestState();
}

late AnimationController _animationControllerL;

HTTPHandlerplaning httpHandlerp = HTTPHandlerplaning();
HTTPHandlerActivites activiteshanhler = HTTPHandlerActivites();
HTTPHandlerActivitestempId activiteshanhlertemp = HTTPHandlerActivitestempId();
final storage = const FlutterSecureStorage();

late Future<List<Item>> item;
//the same
// final httpHandlerp = Get.put(HTTPHandlerplaning());
// late TabController _tabController;
late List<Tab> tabs = [];
late List<Widget> tabViews;
ListPlannings plannig = ListPlannings();
ListActivity activ = ListActivity();
late Future<List<PlanningMainModel>> planninglist;
late Future<List<Activity>> activiteslist;

DateTime? endDate = DateTime.now();
String token = "";
String? baseUrl = "";
String? planningid = "";
int notificationCoun = 0;
DateTime? startDate = DateTime.now();
String baseurl = "https://api.zenify-trip.continuousnet.com/api/activities";
String baseurlA = "https://api.zenify-trip.continuousnet.com/api/activities";
String baseurlp = "https://api.zenify-trip.continuousnet.com/api/plannings";
bool _showWidget = false;
bool showButton = true;
final ImagePicker _picker = ImagePicker();
PickedFile? _imageFile;
PickedFile? _imageFilec;
final httpUserHandler = HttpUserHandler();
List<User>? users;
User? selectedUser = User();
final http1 = Get.put(HTTPHandlerItem());
late bool _showCartBadge;
final String oneSignalAppId = 'a83993b3-1680-49fa-a371-c5ad4c55849a';

class _PlaningtestState extends State<Planingtest>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    print("${widget.touristGroup!.id} widget.touristGuide!.id");

    planningid = widget.planning!.id;

    initializeAsyncState();
    activiteslist = activiteshanhler
        .fetchData("/api/activities/planningIdDs/${widget.planning!.id}");

    _animationControllerL =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // getData();
    getstartDate();
    getenddate();
    _loadUser();
    planninglist = httpHandlerp
        .fetchData("/api/plannings/touristGroupId/${widget.touristGroup!.id}");

    print(activiteslist);
  }

  void _loadUser() async {
    token = (await storage.read(key: "access_token"))!;
    // baseUrl = await storage.read(key: "baseurl");
    setState(() {
      users = []; // initialize the list to an empty list
    });

    final userId = await storage.read(key: "id");
    try {
      final user = await httpUserHandler.fetchUser('/api/users/$userId');

      setState(() {
        users = [user];
        selectedUser = user;
      });
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  List<double> parseCoordinates(String binaryCoordinates) {
    final coordinates = Uint8List.fromList(binaryCoordinates.codeUnits);

    // Extract the longitude value (8 bytes starting from index 5)
    final longitudeBytes = coordinates.sublist(5, 13);
    final longitude = ByteData.view(Uint8List.fromList(longitudeBytes).buffer)
        .getFloat64(0, Endian.big);

    // Extract the latitude value (8 bytes starting from index 13)
    final latitudeBytes = coordinates.sublist(13, 21);
    final latitude = ByteData.view(Uint8List.fromList(latitudeBytes).buffer)
        .getFloat64(0, Endian.big);

    return [latitude, longitude];
  }

  void openMapApp(double latitude, double longitude) async {
    final url = 'geo:$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch map application');
    }
  }

  Future<void> _refreshData() async {
    final startDate = await getStartDateFromApi();
    final endDate = await getenddate();

    final encodedStartDate = Uri.encodeComponent(startDate.toString());
    final encodedEndDate = Uri.encodeComponent(endDate.toString());
    var updatedData = await activiteshanhler.fetchData(
      "/api/activities/planningIdDs/$planningid?startDate=$encodedStartDate&endDate=$encodedEndDate",
    );
    setState(() {
      activiteslist = Future.value(updatedData);
    });
  }

  Future<void> initializeAsyncState() async {
    await Future.delayed(Duration(seconds: 2));
    startDate = await getstartDate();
    endDate = await getenddate();

    print("**********startDate*************************** " +
        startDate.toString());

    Future.delayed(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  Future<DateTime> getstartDate() async {
    var startDate = await getStartDateFromApi();

    return startDate;
  }

  Future<DateTime> getenddate() async {
    var endDate = await gatenddate();

    return endDate;
  }

  Future<DateTime> getStartDateFromApi() async {
    token = (await storage.read(key: "access_token"))!;

    baseUrl = await storage.read(key: "baseurl");
    String baseurlb =
        "https://api.zenify-trip.continuousnet.com/api/plannings/$planningid";

    final respond = await http.get(
      Uri.parse("${baseUrls}/api/plannings/$planningid"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json, text/plain, */*",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
        "Connection": "keep-alive",
      },
    );

    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final startDate = DateTime.parse(data["startDate"]);

      return startDate;
    } else {
      throw Exception('${respond.statusCode}');
    }
  }

  Future<DateTime> gatenddate() async {
    token = (await storage.read(key: "access_token"))!;

    baseUrl = await storage.read(key: "baseurl");
    String baseurlb =
        "https://api.zenify-trip.continuousnet.com/api/plannings/$planningid";
    final respond = await http.get(
      Uri.parse("${baseUrls}/api/plannings/$planningid"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json, text/plain, */*",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
        "Connection": "keep-alive",
      },
    );

    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final startDate = DateTime.parse(data["endDate"]);

      return startDate;
    } else {
      throw Exception('${respond.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    tabViews = [];
    List<Tab> tabs = [];
    for (var date = startDate;
        date!.isBefore(endDate!);
        date = date.add(Duration(days: 1))) {
      tabs.add(Tab(text: '${date.day}/${date.month}'));
    }
    tabViews.add(_buildTabView(endDate!));
    tabs.add(Tab(text: '${endDate!.day}/${endDate!.month}'));

    return RefreshIndicator(
      onRefresh: () => gatenddate(),
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 207, 207, 219),
                      ],
                    ),
                  ),
                ),

                actions: <Widget>[
                  Stack(
                    children: [
                      Row(
                        children: [
                          // badges.Badge(
                          //   position: badges.BadgePosition.topStart(
                          //       top: 2, start: 0.5),
                          //   badgeContent: Text(notificationCoun.toString(),
                          //       style: TextStyle(
                          //         // foreground: Paint()..color = Colors.black,
                          //         color: Color.fromARGB(224, 214, 211, 211),
                          //       )),
                          //   child: IconButton(
                          //     color: Color.fromARGB(255, 209, 204, 204),
                          //     icon: Icon(Icons.notifications),
                          //     onPressed: () async {
                          //       await resetNotificationCount(); // Reset notification count to 0
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 NotificationScreen()),
                          //       );
                          //     },
                          //     // color: Color.fromARGB(219, 39, 38, 40),
                          //   ),
                          // ),

                          // InkWell(
                          //   onTap: () {
                          //     Get.to(GenerateQRPage(
                          //         planningid: widget.planning!.id,
                          //         touristGuideId: widget.touristGroup?.id));
                          //     // Get.to(QrScanner());
                          //   },
                          //   child: SizedBox(
                          //     height: 45,
                          //     child: SvgPicture.asset('assets/scc.svg',
                          //         height: 25,
                          //         width: 25,
                          //         // color: Color.fromARGB(255, 49, 8, 236),
                          //         color: Color.fromARGB(255, 209, 204, 204)),
                          //     // Image.asset('assets/LL.jpg'),
                          //   ),
                          // ),
                          // // IconButton(
                          //   onPressed: () {
                          //     showSearch(
                          //         context: context, delegate: SearchActivity());
                          //   },
                          //   icon: Icon(Icons.search_sharp),
                          // ),
                          // IconButton(
                          //   onPressed: () {
                          //     Get.to(PlanningScreen(planningid));
                          //   },
                          //   icon: Icon(Icons.calendar_month),
                          // ),
                          IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => MainProfile()),
                              // );

                              // Get.to(PushNotificationScreen());
                            },
                            icon: Icon(Icons.notification_add),
                          ),

                          IconButton(
                            splashRadius: 40,
                            iconSize: 30,
                            color: Color.fromARGB(255, 209, 204, 204),
                            onPressed: () {
                              // _animationControllerL.reset();
                              // _animationControllerL.forward();
                              // setState(() {
                              //   _showButton = !_showButton;
                              // });
                              _showMenu(context);
                            },
                            icon: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.dashboard)),
                          ),
                          // IconButton(
                          //   splashRadius: 50,
                          //   iconSize: 100,
                          //   onPressed: () {
                          //     if (_menuController.status == AnimationStatus.dismissed) {
                          //       _menuController.reset();
                          //       _menuController.animateTo(0.6);
                          //     } else {
                          //       _menuController.reverse();
                          //     }
                          //   },
                          //   icon: Lottie.asset(Useanimations.facebook,
                          //       controller: _menuController,
                          //       height: 60,
                          //       fit: BoxFit.fitHeight),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
                backgroundColor: Color.fromARGB(255, 242, 242, 244),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // Get.to(GenerateQRPage(planningid: planningid));
                      },
                      child: SizedBox(
                        height: 45,
                        child: SvgPicture.asset(
                          'assets/Frame.svg',
                          height: 30,
                          width: 30,

                          // color: Color.fromARGB(255, 49, 8, 236),
                        ),
                        // Image.asset('assets/LL.jpg'),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "ZEN",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 233, 3, 3)),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "IFY",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 232, 234, 186)),
                            ),
                          ],
                        ),
                        Text(
                          "Trip",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 232, 111, 113)),
                        ),
                      ],
                    ),
                  ],
                ),
                // const Text('Plannig'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Column(
                    children: [
                      // Text(widget.planning!.id.toString()),
                      // Text(widget.touristGroup!.id.toString()),
                    ],
                  ),
                ),
              ),
            ),
            body: MyScaffold(
              startDate: Uri.encodeComponent(startDate.toString()),
              endDate: Uri.encodeComponent(endDate.toString()),
              activityList: activiteslist,
              planningId: planningid,
              planning: widget.planning,
              touristGroup: widget.touristGroup,
            )),
      ),
    );
  }

  Widget datashow(Activity obj) {
    return Container(
      height: 200,
      child: Card(
        color: Colors.amber,
        child: Column(
          children: [
            Text("id :${obj!.agencyId}"),
            Text("creatorUser :${obj!.creatorUserId}"),
            Text("creatorUser :${obj.agency!.id}"),
            Text("startDate:$startDate"),
            Text("enddate:$endDate"),
          ],
        ),
      ),
    );
  }

// Widget _buildTabView(DateTime date) {
//     // Build the list view for each tab
//     return ListView.builder(
//       itemCount: 10, // Replace with the actual number of items
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text('Item $index on ${date.day}/${date.month}'),
//         );
//       },
//     );
//   }
  Widget _buildTabView(DateTime date) {
    // Fetch the activity data for the given date from the API
    Future<List<String>> _fetchActivityData(DateTime date) async {
      // Replace this with your actual API call to fetch activity data
      await Future.delayed(Duration(seconds: 2)); // Simulate a network delay
      return List.generate(
          10, (index) => 'Activity $index on ${startDate}/${date.month}');
    }

    // Build the list view for each tab
    return FutureBuilder(
      future: _fetchActivityData(date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final activityData = snapshot.data;
          return ListView.builder(
            itemCount: activityData!.length,
            itemBuilder: (context, index) {
              final activity = activityData[index];
              return ListTile(
                title: Text(activity),
              );
            },
          );
        }
      },
    );
  }

  buttonshetCard(index, item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(Icons.image),
          Text('Item$index'),
          Text(item),
          Icon(Icons.list_alt_sharp),
        ],
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  // final DateTime startDate = DateTime.now();
  // final DateTime endDate = DateTime.now().add(Duration(days: 7));
  Timer? timer;
  final String? startDate;
  final String? endDate;
  Future<List<Activity>>? activityList;
  String? planningId;
  PlanningMainModel? planning;
  TouristGroup? touristGroup;
  MyScaffold(
      {this.startDate,
      this.endDate,
      this.activityList,
      this.planningId,
      this.planning,
      this.touristGroup});

  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> with TickerProviderStateMixin {
  @override
  var activiteslist1;
  late ActivityTemplate activites;
  Future<String?> getActivityTemplateId(String activityId) async {
    final String? baseUrl = await storage.read(key: "baseurl");
    final String url = '${baseUrls}/api/activities/$activityId';

    try {
      final http.Response response = await http
          .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? activityTemplateId = responseData['activityTemplateId'];
        return activityTemplateId;
      } else {
        // If the request was unsuccessful, handle the error accordingly
        return null;
      }
    } catch (error) {
      // Handle any exceptions that occurred during the HTTP request
      return null;
    }
  }

  Future<ActivityTemplate> _loadDataActivityTemp(String? activityId) async {
    try {
      // final String activityId = "05e906c8-2d11-4817-81af-5b31990fab3f";
      final String? activityTemplateId =
          await getActivityTemplateId(activityId!);

      if (activityTemplateId != null) {
        final String? baseUrl = await storage.read(key: "baseurl");
        final String activityTemplateUrl =
            '${baseUrls}/api/activity-templates/$activityTemplateId';

        final http.Response response = await http.get(
            headers: {"Authorization": "Bearer $token"},
            Uri.parse(activityTemplateUrl));
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final ActivityTemplate activityTemplate =
              ActivityTemplate.fromJson(responseData);
          return activityTemplate;
        } else {
          throw Exception('Failed to load activity template');
        }
      } else {
        throw Exception('Failed to get activity template ID');
      }
    } catch (error) {
      throw Exception('Failed to load data $error');
    }
  }

  void initState() {
    super.initState();
    // data();
    // _loadData();
    // _lodeaddata();

    data();
  }

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  String _primaryColor = "";

  List<double> parseCoordinates(String binaryCoordinates) {
    final jsonMap = jsonDecode(binaryCoordinates);
    final coordinates = jsonMap['coordinates'] as List<dynamic>;
    final latitude = coordinates[0] as double;
    final longitude = coordinates[1] as double;
    return [latitude, longitude];
  }

  void openMapApp(
    double latitude,
    double longitude, {
    String? placeQuery,
    bool trackLocation = false,
    bool map_action = true,
    Color? color,
    AssetImage? markerImage = const AssetImage('assets/Male.png'),
    // markerImage = const AssetImage('assets/Male.png'),
  }) {
    double zoomLevel = 40;
    String url =
        'geo:$latitude,$longitude?z=$zoomLevel&color=${color!.value.toRadixString(16)}';
    if (placeQuery != null) {
      url += '&q=$placeQuery'; // Add the q parameter with the place query
    }
    if (markerImage != null) {
      url += '&marker=$color'; // Add the marker with the coordinates
    }
    if (placeQuery != null) {
      placeQuery = placeQuery!.replaceAll('{latitude}', '$latitude');
      placeQuery = placeQuery.replaceAll('{longitude}', '$longitude');
      url +=
          '&q=$placeQuery'; // Add the q parameter with the modified place query
    }
    // if (trackLocation) {
    //   Location().enableBackgroundMode(enable: true);
    // }
    url += '&map_action=map';
    print('url $url');
    final encodedUrl = Uri.encodeFull(url);
    launch(encodedUrl);
  }

  Future<List<Activity>>? _lodeaddata() async {
    // String? baseUrl = await storage.read(key: "baseurl");
    setState(() {
      activiteslist1 =
          // activiteshanhler.fetchData("activities?offset=0&limit=2");
          // activiteshanhler.fetchData(
          //     "/api/activities/planningId/$planningid?startDate=${widget.startDate}&endDate=${widget.endDate}");
          activiteshanhler
              .fetchData("/api/activities/planningIdDs/$planningid");
    });
    return activiteslist1;
  }

  // Future<String> getLocationZone(dynamic? activityid) async {
  //   final activityTemp = await _loadDataActivityTemp(activityid);
  //   dynamic coordinates = activityTemp.coordinates;

  //   if (coordinates != null) {
  //     final binaryCoordinates = jsonEncode(coordinates);
  //     final parsedCoordinates = parseCoordinates(binaryCoordinates);
  //     final latitude = parsedCoordinates[0];
  //     final longitude = parsedCoordinates[1];
  //     final placeQuery = '$latitude $longitude';
  //     // final double latitude = coordinates.latitude;
  //     // final double longitude = coordinates.longitude;

  //     final List<geocoding.Placemark> placemarks =
  //         await geocoding.placemarkFromCoordinates(latitude, longitude);

  //     final geocoding.Placemark placemark = placemarks.first;
  //     final String zone = placemark.administrativeArea ?? '';

  //     print("$zone zone");
  //     return zone;
  //   }

  //   return 'zone';
  // }

  // Future<String> getpostalCode(dynamic? activityid) async {
  //   final activityTemp = await _loadDataActivityTemp(activityid);
  //   dynamic coordinates = activityTemp.coordinates;
  //   if (coordinates != null) {
  //     final binaryCoordinates = jsonEncode(coordinates);
  //     final parsedCoordinates = parseCoordinates(binaryCoordinates);
  //     final latitude = parsedCoordinates[0];
  //     final longitude = parsedCoordinates[1];
  //     final placeQuery = '$latitude $longitude';
  //     // final double latitude = coordinates.latitude;
  //     // final double longitude = coordinates.longitude;

  //     final List<geocoding.Placemark> placemarks =
  //         await geocoding.placemarkFromCoordinates(latitude, longitude);

  //     final geocoding.Placemark placemark = placemarks.first;
  //     final String zone = placemark.country ?? '';

  //     print("$zone zone");
  //     return zone;
  //   }

  //   return '';
  // }

  Future<List<Activity>>? data() {
    setState(() {
      activiteslist = _lodeaddata()!;
    });

    return activiteslist;
  }

  // Widget _shoppingCartBadge() {
  //   return badges.Badge(
  //     position: badges.BadgePosition.topEnd(top: 0, end: 3),
  //     badgeAnimation: badges.BadgeAnimation.slide(
  //         // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
  //         // curve: Curves.easeInCubic,
  //         ),
  //     showBadge: _showCartBadge,
  //     badgeStyle: badges.BadgeStyle(
  //       badgeColor: Colors.black12,
  //     ),
  //     badgeContent: Text(
  //       notificationCoun.toString(),
  //       style: TextStyle(color: Color.fromARGB(255, 209, 204, 204)),
  //     ),
  //     child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
// final List<DateTime> dates = getRangeOfDates(startDate, endDate);
    return
// _isLoading
//         ? Center(child: CircularProgressIndicator())
        // :
        DefaultTabController(
      length: endDate!.difference(startDate!.add(Duration(days: -1))).inDays,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 207, 207, 219),
                  ],
                ),
              ),
            ),
            leading: InkWell(
              onTap: () {
                print("hi");
              },
              child: SizedBox(
                width: 200,
                height: 200,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text('Planning'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('  MMMM  d ,y ').format(startDate!),
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 240, 238, 238)),
                    ),
                    Text(
                      DateFormat('   ~   MMMM  d ,y ').format(endDate!),
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 248, 247, 247)),
                    ),
                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(210, 255, 255, 255),
                      Color.fromARGB(255, 189, 4, 4)
                    ],
                  ),
                ),
                child: buildTabBar(
                  startDate!,
                  endDate!,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: List.generate(
              endDate!.difference(startDate!).inHours,
              (index) => _buildTabView(startDate!.add(Duration(days: index))),
            ),
          )),
    );
  }

  Widget _buildTabView(DateTime date) {
    Future<List<Activity>> _fetchActivityData(DateTime date) async {
      final activities = await data();
      return activities!
          .where((activity) =>
              activity.departureDate != null &&
              activity.returnDate != null &&
              activity.departureDate!.isBefore(date.add(Duration(days: 1))) &&
              activity.returnDate!.isAfter(date.add(Duration(days: 0))))
          .toList();
    }

    // Build the list view for each tab
    return RefreshIndicator(
      onRefresh: () => _fetchActivityData(date),
      child: FutureBuilder<List<Activity>>(
        future: _fetchActivityData(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 245, 243, 243),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 24, 10, 221)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [
                // if (snapshot
                //     .hasError) // Display error message if there's an error
                //   RefreshIndicator(
                //       onRefresh: () => _fetchActivityData(date),
                //       child: Text('Error: ${snapshot.error}')),
                // ElevatedButton(
                //   onPressed: () {
                //     Get.to(AddActivityScreen(
                //       touristGroup: widget.touristGroup,
                //     )) as String;
                //   },
                //   child: Text('Add Activity'),
                // ),
                // Text('Error: ${snapshot.error}'),
              ],
            ));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // No activities found for this date.
            return InkWell(
              onTap: () {
                // Get.to(AddActivityScreen(
                //   touristGroup: widget.touristGroup,
                // )) as String;
              },
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/404.png', // Replace with your PNG image path
                      // width: Get.w, // Set the width of the image (optional)
                      height: Get.height *
                          0.3, // Set the height of the image (optional)
                      fit: BoxFit.fitWidth, // Set the fit mode (optional)
                    ),

                    Text(
                      'No activities  for this Day ${DateFormat('EEE, MMM d').format(date)}',
                      style: TextStyle(fontSize: 20, color: Colors.brown),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:
                            pickerColor, // Set the button's background color
                        onPrimary: Colors.white, // Set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set button corner radius
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10), // Button padding
                        textStyle:
                            TextStyle(fontSize: 18), // Text style of the button
                      ),
                      onPressed: () {
                        // Get.to(AddActivityScreen(
                        //   touristGroup: widget.touristGroup,
                        // )) as String;
                      },
                      child: Text('Clik to Add Activity'),
                    ),
                    // Text('Error: ${snapshot.error}'),
                  ],
                ),
              ),
            );
          } else {
            final activityData = snapshot.data;
            return Column(
              children: [
                Container(
                    margin:
                        EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                    padding: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(210, 55, 4, 221),
                          Color.fromARGB(255, 189, 4, 4)
                        ],
                      ),
                    )),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 10),
                    separatorBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 5, right: 5),
                          padding: EdgeInsets.only(top: 1, bottom: 1),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(210, 55, 4, 221),
                                Color.fromARGB(255, 189, 4, 4)
                              ],
                            ),
                          ));
                    },
                    itemCount: activityData!.length,
                    itemBuilder: (context, index) {
                      final activity = activityData[index];
                      return buildCard(snapshot.data![index], index);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  buildCard(
    Activity activity,
    index,
  ) {
    bool _isLoading = false;
    void changedata() {
      setState(() {
        _isLoading = false;
      });
    }

    void handleDetailUpdate(String field, String updatedValue) {
      // Update the screen detail based on the field and updated value
      setState(() {
        if (field == 'name') {
          activity?.name = updatedValue;
        } else if (field == 'babyPrice') {
          activity?.babyPrice = double.tryParse(updatedValue);
        } else if (field == 'childPrice') {
          activity?.childPrice = double.tryParse(updatedValue);
        } else if (field == 'primaryColor') {
          activity?.primaryColor = updatedValue;
        } else if (field == 'secondaryColor') {
          activity?.primaryColor = updatedValue;
        }
        // Add more conditions for other fields if needed
      });
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 219, 10, 10),
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 24, 10, 221)),
            ),
          )
        : InkWell(
            onTap: () {
              print(index);
              // Get.to(activitydetalSecreen(activity, token));
            },
            child: Card(
              elevation: 20,
              color: activity.activityTemplate!.primaryColor != null
                  ? Color(int.parse(
                          activity.activityTemplate!.primaryColor!.substring(1),
                          radix: 16))
                      .withOpacity(0.55)
                  : Color.fromARGB(0, 14, 197, 197),
              shadowColor: activity.activityTemplate!.primaryColor != null
                  ? Color(int.parse(
                          activity.activityTemplate!.primaryColor!.substring(2),
                          radix: 16))
                      .withOpacity(1)
                  : Color.fromARGB(249, 51, 14, 197),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: activity.activityTemplate!.primaryColor != null
                      ? Color(int.parse(
                              activity.activityTemplate!.primaryColor!
                                  .substring(1),
                              radix: 16))
                          .withOpacity(0.8)
                      : Color.fromARGB(0, 14, 197, 197),
                  width: 3,
                ),
              ),
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Container(
                  height: Get.height * 0.35,
                  color: activity.activityTemplate!.primaryColor != null
                      ? Color.fromARGB(0, 14, 197, 197)
                      : Color.fromARGB(0, 14, 197, 197),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          activity.activityTemplate!.primaryColor != null
                              ? Color(int.parse(
                                      activity.activityTemplate!.primaryColor!
                                          .substring(1),
                                      radix: 16))
                                  .withOpacity(0.8)
                              : Color.fromARGB(0, 15, 15, 15),
                          activity.secondaryColor != null
                              ? Color(int.parse(
                                      activity.secondaryColor!.substring(1),
                                      radix: 16))
                                  .withOpacity(0.8)
                              : Color.fromARGB(0, 15, 15, 15),
                        ],
                      ),
                    ),
                    height: Get.height * 0.37,
                    margin: const EdgeInsets.only(left: 2),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${DateFormat('EEE, MMM d').format(activity.departureDate ?? DateTime.now())} ${DateFormat(' ~ EEE, MMM d').format(activity.returnDate ?? DateTime.now())}"
                                  // "${DateFormat(' kk:mm ').format(DateTime.now())}  ${DateFormat('- kk:mm ').format(DateTime.now())}",
                                  ,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    color: activity.secondaryColor != null
                                        ? Color(int.parse(
                                                activity.secondaryColor!
                                                    .substring(1),
                                                radix: 16))
                                            .withOpacity(0.55)
                                        : Color.fromARGB(255, 209, 204, 204),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        popupMenuTheme: PopupMenuThemeData(
                                          color: activity.activityTemplate!
                                                      .primaryColor !=
                                                  null
                                              ? Color(int.parse(
                                                      activity.activityTemplate!
                                                          .primaryColor!
                                                          .substring(1),
                                                      radix: 16))
                                                  .withOpacity(0.7)
                                              : Color.fromARGB(
                                                  255, 14, 197, 197),
                                          textStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255,
                                                  241,
                                                  231,
                                                  231)), // Set the desired text color
                                          // Add more customization options as needed
                                        ),
                                      ),
                                      child: PopupMenuButton<String>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30), // Replace with desired border radius
                                          // Other shape customization properties
                                        ),
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'Categories',
                                            child: ListTile(
                                              title: Text(
                                                'Categories',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255,
                                                      241,
                                                      231,
                                                      231), // Set the desired text color
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.looks_3_outlined,

                                                color: Color.fromARGB(
                                                    255,
                                                    241,
                                                    231,
                                                    231), // Set the desired text color
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'update',
                                            child: ListTile(
                                              title: Text(
                                                'Update',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255,
                                                      241,
                                                      231,
                                                      231), // Set the desired text color
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.update,
                                                color: Color.fromARGB(
                                                    255, 209, 204, 204),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'Add new planning',
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.add,
                                                color: Color.fromARGB(
                                                    255, 241, 231, 231),
                                              ),
                                              title: Text(
                                                'Create  planning',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 209, 204, 204),
                                                ), // Set the desired text color
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'Add new Activity',
                                            child: ListTile(
                                                title: Text(
                                                  'Create  Activity',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255,
                                                        241,
                                                        231,
                                                        231), // Set the desired text color
                                                  ),
                                                ),
                                                leading: Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      255, 241, 231, 231),
                                                )),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: ListTile(
                                              title: Text(
                                                'Delet Activity',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255,
                                                      241,
                                                      231,
                                                      231), // Set the desired text color
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.delete_forever,
                                                color: Color.fromARGB(
                                                    255, 241, 231, 231),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'color',
                                            child: ListTile(
                                              title: Text(
                                                'Change text color',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255,
                                                      241,
                                                      231,
                                                      231), // Set the desired text color
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.color_lens,

                                                color: Color.fromARGB(
                                                    255,
                                                    241,
                                                    231,
                                                    231), // Set the desired text color
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'primaryColor',
                                            child: ListTile(
                                              title: Text(
                                                'Change Card color',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255,
                                                      241,
                                                      231,
                                                      231), // Set the desired text color
                                                ),
                                              ),
                                              leading: Icon(
                                                Icons.color_lens,

                                                color: Color.fromARGB(
                                                    255,
                                                    241,
                                                    231,
                                                    231), // Set the desired text color
                                              ),
                                            ),
                                          ),
                                        ],
                                        onSelected: (String value) async {
                                          if (value == 'delete') {
                                            bool confirmed = await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Confirmation"),
                                                content: Text(
                                                    "Are you sure you want to delete this activity?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirmed != null &&
                                                confirmed) {
                                              token = (await storage.read(
                                                  key: "access_token"))!;
                                              String? baseUrl = await storage
                                                  .read(key: "baseurl");
                                              final response =
                                                  await http.delete(
                                                Uri.parse(
                                                    '${baseUrls}/api/activities/${activity.id}'),
                                                headers: {
                                                  'accept': 'application/json',
                                                  'Authorization':
                                                      'Bearer $token',
                                                  'Content-Type':
                                                      'application/json',
                                                },
                                              );

                                              if (response.statusCode == 204) {
                                                // Activity successfully deleted
                                                // final snackBar = SnackBar(
                                                //   elevation: 0,
                                                //   behavior:
                                                //       SnackBarBehavior.floating,
                                                //   backgroundColor:
                                                //       Colors.transparent,
                                                //   content:
                                                //       AwesomeSnackbarContent(
                                                //     title:
                                                //         'Yap Activity deleted success! ${activity.name}',
                                                //     message: '',
                                                //     contentType:
                                                //         ContentType.success,
                                                //   ),
                                                // );
                                                // ScaffoldMessenger.of(context)
                                                //   ..hideCurrentSnackBar()
                                                //   ..showSnackBar(snackBar);
                                                // Get.to(Planingtest());
                                                print(response.statusCode);
                                                setState(() {
                                                  // Update the state of the widget
                                                  _isLoading = true;
                                                });
                                              } else {
                                                // Error occurred while deleting activity
                                                print(
                                                    '${response.statusCode} 123');
                                              }
                                            }

                                            // Perform delete action
                                          } else if (value == 'update') {
                                            // Get.to(updateActivityScreen(
                                            //     activity: activity,
                                            //     touristGuideid:
                                            //         widget.touristGroup!.id));
                                            // Perform update action
                                          } else if (value == 'primaryColor') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Pick a Card  color!'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged:
                                                          changeColor,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            pickerColor, // Set the button's background color
                                                        onPrimary: Colors
                                                            .white, // Set the text color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10), // Set button corner radius
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical:
                                                                    10), // Button padding
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                18), // Text style of the button
                                                      ),
                                                      child:
                                                          const Text('Got it'),
                                                      onPressed: () {
                                                        setState(
                                                          () => currentColor =
                                                              pickerColor,
                                                        );
                                                        setState(() => activity
                                                                ?.primaryColor =
                                                            '#${pickerColor.value.toRadixString(16).substring(2, 8)}');
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Get.to(
                                                        //   UpdateActivityDetailDialog(
                                                        //       field:
                                                        //           'primaryColor',
                                                        //       initialValue:
                                                        //           activity?.primaryColor ??
                                                        //               '',
                                                        //       activity:
                                                        //           activity,
                                                        //       onUpdateDetail:
                                                        //           handleDetailUpdate,
                                                        //       baseUrl:
                                                        //           baseUrls),
                                                        // );
                                                        //  Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // showDialog(
                                            //   context: context,
                                            //   builder: (context) =>
                                            //       UpdateActivityDetailDialog(
                                            //           field: 'secondaryColor',
                                            //           initialValue:
                                            //               activity?.secondaryColor ??
                                            //                   '',
                                            //           activity: activity,
                                            //            onUpdateDetail:
                                            //                handleDetailUpdate,
                                            //           baseUrl: baseUrl),
                                            // );
                                            //                                       Get.to(
                                            // updateActivityScreen(
                                            //                                           activity: activity,
                                            //                                           touristGuideid:
                                            //                                               widget.touristGroup!.id));
                                            // Perform update action
                                          } else if (value == 'color') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Pick a text color!'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged:
                                                          changeColor,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            pickerColor, // Set the button's background color
                                                        onPrimary: Colors
                                                            .white, // Set the text color
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10), // Set button corner radius
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical:
                                                                    10), // Button padding
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                18), // Text style of the button
                                                      ),
                                                      child:
                                                          const Text('Got it'),
                                                      onPressed: () {
                                                        setState(
                                                          () => currentColor =
                                                              pickerColor,
                                                        );
                                                        setState(() => activity
                                                                ?.secondaryColor =
                                                            '#${pickerColor.value.toRadixString(16).substring(2, 8)}');
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Get.to(
                                                        //   UpdateActivityDetailDialog(
                                                        //       field:
                                                        //           'secondaryColor',
                                                        //       initialValue:
                                                        //           activity?.secondaryColor ??
                                                        //               '',
                                                        //       activity:
                                                        //           activity,
                                                        //       onUpdateDetail:
                                                        //           handleDetailUpdate,
                                                        //       baseUrl:
                                                        //           baseUrls),
                                                        // );
                                                        //  Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // showDialog(
                                            //   context: context,
                                            //   builder: (context) =>
                                            //       UpdateActivityDetailDialog(
                                            //           field: 'secondaryColor',
                                            //           initialValue:
                                            //               activity?.secondaryColor ??
                                            //                   '',
                                            //           activity: activity,
                                            //            onUpdateDetail:
                                            //                handleDetailUpdate,
                                            //           baseUrl: baseUrl),
                                            // );
                                            //                                       Get.to(
                                            // updateActivityScreen(
                                            //                                           activity: activity,
                                            //                                           touristGuideid:
                                            //                                               widget.touristGroup!.id));
                                            // Perform update action
                                          } else if (value == 'Categories') {
                                            // Get.to(AddActivityTempScreen());
                                            // Perform update action
                                          } else if (value ==
                                              'Add new planning') {
                                            // Get.to(AddPlanningScreen());
                                            // Perform update action
                                          } else if (value ==
                                              'Add new Activity') {
                                            // Get.to(AddActtivityForm(activity: activity));
                                            // String ref = Get.to(
                                            //     AddActivityScreen(
                                            //         touristGroup:
                                            //             widget.touristGroup,
                                            //         planning: widget
                                            //             .planning)) as String;
                                            // if (ref == 'r') {
                                            //   setState(() {
                                            //     _isLoading = true;
                                            //     changedata();
                                            //   });
                                            // }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: activity.secondaryColor != null
                                              ? Color(int.parse(
                                                      activity.secondaryColor!
                                                          .substring(1),
                                                      radix: 16))
                                                  .withOpacity(0.55)
                                              : Color.fromARGB(
                                                  255, 209, 204, 204),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 0.02,
                                )
                              ],
                            ),
                            Text(
                              " Start at ${DateFormat('HH:mm').format(activity.departureDate ?? DateTime.now())} ${DateFormat('HH:mm').format(activity.returnDate ?? DateTime.now())}"
                              // "${DateFormat(' kk:mm ').format(DateTime.now())}  ${DateFormat('- kk:mm ').format(DateTime.now())}",
                              ,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: activity.secondaryColor != null
                                    ? Color(int.parse(
                                            activity.secondaryColor!
                                                .substring(1),
                                            radix: 16))
                                        .withOpacity(0.55)
                                    : Color.fromARGB(255, 209, 204, 204),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                          child: GestureDetector(
                            onLongPress: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) =>
                              //       UpdateActivityDetailDialog(
                              //           field: 'primaryColor',
                              //           initialValue:
                              //               activity?.primaryColor ?? '',
                              //           activity: activity,
                              //           onUpdateDetail: handleDetailUpdate,
                              //           baseUrl: baseUrls),
                              // );
                            },
                            child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: activity.activityTemplate!
                                                .primaryColor !=
                                            null
                                        ? Color(int.parse(
                                                activity.activityTemplate!
                                                    .primaryColor!
                                                    .substring(1),
                                                radix: 16))
                                            .withOpacity(0.5)
                                        : Color.fromARGB(255, 0, 29, 158),
                                    // width: 2,
                                  ),
                                ),
                                color:
                                    activity.activityTemplate!.primaryColor !=
                                            null
                                        ? Color(int.parse(
                                                activity.activityTemplate!
                                                    .primaryColor!
                                                    .substring(1),
                                                radix: 16))
                                            .withOpacity(0.05)
                                        : Color.fromARGB(255, 13, 0, 155),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        // Add your function here
                                        // Get.to(UploadScreen(activity));
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         FileUploadScreen(
                                        //       dynamicPath:
                                        //           'Mobile/ActivityTemplate',
                                        //       id: activity.activityTemplateId ??
                                        //           "",
                                        //       fild: 'picture',
                                        //       object: "api/activity-templates",
                                        //     ), // Replace with your dynamic path
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        width:
                                            100, // Set the desired width for the image
                                        height:
                                            200, // Set the desired height for the image
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: activity.activityTemplate!
                                                        .picture ==
                                                    null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRWdJi2AjWfvDp7-D0IAvDYdKZqvLH9kwBUaPLoarHgw&s',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                      '${baseUrls}/assets/uploads/Mobile/ActivityTemplate/${activity.activityTemplate!.picture}',
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $token',
                                                      },
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )),
                                      ),
                                    ),
                                    // Add spacing between the image and the text
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          print(index);
                                          // Get.to(activitydetalSecreen(
                                          //     activity, token));
                                        },
                                        child: InkWell(
                                          //  onLongPress: updatePhoneNumberDialog,
                                          onDoubleTap: () {
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (context) =>
                                            //       UpdateActivityDetailDialog(
                                            //           field: 'name',
                                            //           initialValue:
                                            //               activity?.name ?? '',
                                            //           activity: activity,
                                            //           onUpdateDetail:
                                            //               handleDetailUpdate,
                                            //           baseUrl: baseUrls),
                                            // );
                                          },
                                          child: Text(
                                            activity.name?.toString() ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: 24,
                                              height: 0,
                                              fontStyle: FontStyle.italic,
                                              color: activity.secondaryColor !=
                                                      null
                                                  ? Color(int.parse(
                                                          activity
                                                              .secondaryColor!
                                                              .substring(1),
                                                          radix: 16))
                                                      .withOpacity(0.55)
                                                  : Color.fromARGB(
                                                      255, 209, 204, 204),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [],
                                    ),
                                    SizedBox(width: 30),
                                    SizedBox(width: 30),
                                  ],
                                )),
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(47, 0, 0, 0),
                          indent: 8,
                          endIndent: 8,
                          thickness: 1.5,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.man_3,
                                          color: activity.secondaryColor != null
                                              ? Color(int.parse(
                                                      activity.secondaryColor!
                                                          .substring(1),
                                                      radix: 16))
                                                  .withOpacity(0.55)
                                              : Color.fromARGB(
                                                  255, 209, 204, 204),
                                        ),
                                        Text(
                                          ": ${activity.adultPrice} ${activity.currency}  " ??
                                              '',
                                          style: TextStyle(
                                            color: activity.secondaryColor !=
                                                    null
                                                ? Color(int.parse(
                                                        activity.secondaryColor!
                                                            .substring(1),
                                                        radix: 16))
                                                    .withOpacity(0.55)
                                                : Color.fromARGB(
                                                    255, 209, 204, 204),
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                      width:
                                          10, // Set the desired height for the vertical Divider
                                      child: VerticalDivider(
                                          color: Color.fromARGB(
                                              255, 209, 204, 204)),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.child_friendly_outlined,
                                          color: activity.secondaryColor != null
                                              ? Color(int.parse(
                                                      activity.secondaryColor!
                                                          .substring(1),
                                                      radix: 16))
                                                  .withOpacity(0.55)
                                              : Color.fromARGB(
                                                  255, 209, 204, 204),
                                        ),
                                        Text(
                                          ": ${activity.childPrice} ${activity.currency}",
                                          style: TextStyle(
                                            color: activity.secondaryColor !=
                                                    null
                                                ? Color(int.parse(
                                                        activity.secondaryColor!
                                                            .substring(1),
                                                        radix: 16))
                                                    .withOpacity(0.55)
                                                : Color.fromARGB(
                                                    255, 209, 204, 204),
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      width:
                                          10, // Set the desired height for the vertical Divider
                                      child: VerticalDivider(
                                          color: Color.fromARGB(
                                              255, 209, 204, 204)),
                                    ),
                                    InkWell(
                                      //  onLongPress: updatePhoneNumberDialog,
                                      onDoubleTap: () {
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (context) =>
                                        //       UpdateActivityDetailDialog(
                                        //           field: 'babyPrice',
                                        //           initialValue: activity
                                        //                   ?.babyPrice
                                        //                   .toString() ??
                                        //               '',
                                        //           activity: activity,
                                        //           onUpdateDetail:
                                        //               handleDetailUpdate,
                                        //           baseUrl: baseUrls),
                                        // );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.child_care,
                                            color: activity.secondaryColor !=
                                                    null
                                                ? Color(int.parse(
                                                        activity.secondaryColor!
                                                            .substring(1),
                                                        radix: 16))
                                                    .withOpacity(0.55)
                                                : Color.fromARGB(
                                                    255, 209, 204, 204),
                                          ),
                                          Text(
                                            ": ${activity.babyPrice} ${activity.currency}",
                                            style: TextStyle(
                                              color: activity.secondaryColor !=
                                                      null
                                                  ? Color(int.parse(
                                                          activity
                                                              .secondaryColor!
                                                              .substring(1),
                                                          radix: 16))
                                                      .withOpacity(0.55)
                                                  : Color.fromARGB(
                                                      255, 209, 204, 204),
                                              fontSize: 14,
                                              // fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width:
                                                12, // Set the desired height for the vertical Divider
                                            child: VerticalDivider(
                                                color: Color.fromARGB(
                                                    255, 209, 204, 204)),
                                          ),
                                          // FutureBuilder<String>(
                                          //   future:
                                          //       getLocationZone(activity.id),
                                          //   builder: (BuildContext context,
                                          //       AsyncSnapshot<String>
                                          //           snapshot) {
                                          //     if (snapshot.connectionState ==
                                          //         ConnectionState.waiting) {
                                          //       return Text(
                                          //         'Loading ',
                                          //         style: TextStyle(
                                          //           fontSize: 10,
                                          //           fontWeight: FontWeight.w300,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     } else if (snapshot.hasError) {
                                          //       return Text(
                                          //         'Error  ',
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w200,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     } else {
                                          //       return Text(
                                          //         snapshot.data ??
                                          //             'No zone available',
                                          //         style: TextStyle(
                                          //           fontSize: 10,
                                          //           fontWeight: FontWeight.w900,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     }
                                          //   },
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 30),
                                          Text(
                                            'Contry : ',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: activity.secondaryColor !=
                                                      null
                                                  ? Color(int.parse(
                                                          activity
                                                              .secondaryColor!
                                                              .substring(1),
                                                          radix: 16))
                                                      .withOpacity(0.55)
                                                  : Color.fromARGB(
                                                      255, 209, 204, 204),
                                            ),
                                          ),
                                          // FutureBuilder<String>(
                                          //   future: getpostalCode(activity.id),
                                          //   builder: (BuildContext context,
                                          //       AsyncSnapshot<String>
                                          //           snapshot) {
                                          //     if (snapshot.connectionState ==
                                          //         ConnectionState.waiting) {
                                          //       return Text(
                                          //         'Loading ',
                                          //         style: TextStyle(
                                          //           fontSize: 5,
                                          //           fontWeight: FontWeight.w900,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     } else if (snapshot.hasError) {
                                          //       return Text(
                                          //         'Error  ',
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w200,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     } else {
                                          //       return Text(
                                          //         snapshot.data ?? 'No zone',
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w900,
                                          //           color: activity
                                          //                       .secondaryColor !=
                                          //                   null
                                          //               ? Color(int.parse(
                                          //                       activity
                                          //                           .secondaryColor!
                                          //                           .substring(
                                          //                               1),
                                          //                       radix: 16))
                                          //                   .withOpacity(0.55)
                                          //               : Color.fromARGB(
                                          //                   255, 209, 204, 204),
                                          //         ),
                                          //       );
                                          //     }
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 4,
                            // ),
                            const Divider(
                              color: Color.fromARGB(47, 0, 0, 0),
                              indent: 8,
                              endIndent: 8,
                              thickness: 1.5,
                            ),

                            Row(
                              children: [
                                const SizedBox(width: 16),
                                SizedBox(width: 20),
                                Icon(
                                  Icons.account_box,
                                  color: activity.secondaryColor != null
                                      ? Color(int.parse(
                                              activity.secondaryColor!
                                                  .substring(1),
                                              radix: 16))
                                          .withOpacity(0.55)
                                      : Color.fromARGB(255, 209, 204, 204),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.map,
                                    color: activity.secondaryColor != null
                                        ? Color(int.parse(
                                                activity.secondaryColor!
                                                    .substring(1),
                                                radix: 16))
                                            .withOpacity(0.55)
                                        : Color.fromARGB(255, 209, 204, 204),
                                  ),
                                  onPressed: () async {
                                    final activityTemplate =
                                        await _loadDataActivityTemp(
                                            activity.id!);
                                    if (activityTemplate != null &&
                                        activityTemplate.coordinates != null) {
                                      final coordinates =
                                          activityTemplate.coordinates!;
                                      final binaryCoordinates =
                                          jsonEncode(coordinates);
                                      final parsedCoordinates =
                                          parseCoordinates(binaryCoordinates);
                                      final latitude = parsedCoordinates[0];
                                      final longitude = parsedCoordinates[1];
                                      final placeQuery = '$latitude $longitude';
                                      final c = Colors.blue;
                                      // getLocationZone(latitude, longitude);
                                      openMapApp(
                                        latitude,
                                        longitude,
                                        placeQuery: placeQuery,
                                        trackLocation: true,
                                        color: c,
                                        markerImage:
                                            const AssetImage('assets/Male.png'),
                                        map_action: true,
                                      );

                                      print(
                                          "binaryCoordinates $binaryCoordinates");
                                      print("latitude $latitude");
                                      print("longitude $longitude");
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.comment,
                                        color: activity.secondaryColor != null
                                            ? Color(int.parse(
                                                    activity.secondaryColor!
                                                        .substring(1),
                                                    radix: 16))
                                                .withOpacity(0.55)
                                            : Color.fromARGB(
                                                255, 209, 204, 204),
                                      ),
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => CommentScreen(
                                        //         activity: activity),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    Text(
                                      " Comments..",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: activity.secondaryColor != null
                                            ? Color(int.parse(
                                                    activity.secondaryColor!
                                                        .substring(1),
                                                    radix: 16))
                                                .withOpacity(0.55)
                                            : Color.fromARGB(
                                                255, 209, 204, 204),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

//   buildCardtest(
//     Activity activity,
//     index,
//   ) {
//     bool _isLoading = false;
//     void changedata() {
//       setState(() {
//         _isLoading = false;
//       });
//     }

//     List<String> _selectedOptions1 = List.filled(1000, 'Status');

//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Color.fromARGB(255, 219, 10, 10),
//               valueColor: new AlwaysStoppedAnimation<Color>(
//                   Color.fromARGB(255, 24, 10, 221)),
//             ),
//           )
//         : Card(
//             elevation: 40,
//             shadowColor: Color.fromARGB(255, 193, 15, 15),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//               side: BorderSide(
//                 color: activity.activityTemplate!.primaryColor != null
//                     ? Color(int.parse(
//                             activity.activityTemplate!.primaryColor!
//                                 .substring(1),
//                             radix: 16))
//                         .withOpacity(0.1)
//                     : Color.fromARGB(255, 14, 197, 197),
//                 width: 2,
//               ),
//               // borderRadius: BorderRadius.circular(50),
//             ),
//             margin: const EdgeInsets.only(left: 16, right: 16),
//             child: Container(
//               clipBehavior: Clip.hardEdge,
//               color: activity.activityTemplate!.primaryColor != null
//                   ? Color(int.parse(
//                           activity.activityTemplate!.primaryColor!.substring(1),
//                           radix: 16))
//                       .withOpacity(0.5)
//                   : Color.fromARGB(255, 14, 197, 197),
//               child: Container(
//                 height: Get.height * 0.35,
//                 margin: const EdgeInsets.only(left: 2),
//                 child: Column(
//                   // mainAxisSize: MainAxisSize.min,

//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                             "${DateFormat('EEE, MMM d').format(activity.departureDate ?? DateTime.now())} ${DateFormat(' ~ EEE, MMM d').format(activity.returnDate ?? DateTime.now())}"
//                             // "${DateFormat(' kk:mm ').format(DateTime.now())}  ${DateFormat('- kk:mm ').format(DateTime.now())}",
//                             ,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontStyle: FontStyle.italic,
//                               fontWeight: FontWeight.w600,
//                             )),
//                         Row(
//                           children: [

// //
//                             Theme(
//                               data: Theme.of(context).copyWith(
//                                 popupMenuTheme: PopupMenuThemeData(
//                                   color:
//                                       activity.activityTemplate!.primaryColor !=
//                                               null
//                                           ? Color(int.parse(
//                                                   activity.activityTemplate!
//                                                       .primaryColor!
//                                                       .substring(1),
//                                                   radix: 16))
//                                               .withOpacity(0.5)
//                                           : Color.fromARGB(255, 14, 197, 197),
//                                   textStyle: TextStyle(
//                                       color: Color.fromARGB(255, 241, 231,
//                                           231)), // Set the desired text color
//                                   // Add more customization options as needed
//                                 ),
//                               ),
//                               child: PopupMenuButton<String>(
//                                 itemBuilder: (BuildContext context) =>
//                                     <PopupMenuEntry<String>>[
//                                   PopupMenuItem<String>(
//                                     value: 'delete',
//                                     child: ListTile(
//                                       title: Text(
//                                         'Delet Activity',
//                                         style: TextStyle(
//                                           color: Color.fromARGB(255, 241, 231,
//                                               231), // Set the desired text color
//                                         ),
//                                       ),
//                                       leading: Icon(
//                                         Icons.delete_forever,
//                                         color:
//                                             Color.fromARGB(255, 241, 231, 231),
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem<String>(
//                                     value: 'Categories',
//                                     child: ListTile(
//                                       title: Text(
//                                         'Categories',
//                                         style: TextStyle(
//                                           color: Color.fromARGB(255, 241, 231,
//                                               231), // Set the desired text color
//                                         ),
//                                       ),
//                                       leading: Icon(
//                                         Icons.looks_3_outlined,

//                                         color: Color.fromARGB(255, 241, 231,
//                                             231), // Set the desired text color
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem<String>(
//                                     value: 'update',
//                                     child: ListTile(
//                                       title: Text(
//                                         'Update',
//                                         style: TextStyle(
//                                           color: Color.fromARGB(255, 241, 231,
//                                               231), // Set the desired text color
//                                         ),
//                                       ),
//                                       leading: Icon(
//                                         Icons.update,
//                                         color:
//                                             Color.fromARGB(255, 241, 231, 231),
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem<String>(
//                                     value: 'Add new planning',
//                                     child: ListTile(
//                                       leading: Icon(
//                                         Icons.add,
//                                         color:
//                                             Color.fromARGB(255, 241, 231, 231),
//                                       ),
//                                       title: Text(
//                                         'Create  planning',
//                                         style: TextStyle(
//                                           color: Color.fromARGB(255, 241, 231,
//                                               231), // Set the desired text color
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem<String>(
//                                     value: 'Add new Activity',
//                                     child: ListTile(
//                                         title: Text(
//                                           'Create  Activity',
//                                           style: TextStyle(
//                                             color: Color.fromARGB(255, 241, 231,
//                                                 231), // Set the desired text color
//                                           ),
//                                         ),
//                                         leading: Icon(
//                                           Icons.add,
//                                           color: Color.fromARGB(
//                                               255, 241, 231, 231),
//                                         )),
//                                   ),
//                                 ],
//                                 onSelected: (String value) async {
//                                   if (value == 'delete') {
//                                     bool confirmed = await showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: Text("Confirmation"),
//                                         content: Text(
//                                             "Are you sure you want to delete this activity?"),
//                                         actions: <Widget>[
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.of(context)
//                                                     .pop(false),
//                                             child: Text("Cancel"),
//                                           ),
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.of(context).pop(true),
//                                             child: Text("Delete"),
//                                           ),
//                                         ],
//                                       ),
//                                     );

//                                     if (confirmed != null && confirmed) {
//                                       token = (await storage.read(
//                                           key: "access_token"))!;
//                                       String? baseUrl =
//                                           await storage.read(key: "baseurl");
//                                       final response = await http.delete(
//                                         Uri.parse(
//                                             '${baseUrls}/api/activities/${activity.id}'),
//                                         headers: {
//                                           'accept': 'application/json',
//                                           'Authorization': 'Bearer $token',
//                                           'Content-Type': 'application/json',
//                                         },
//                                       );

//                                       if (response.statusCode == 204) {
//                                         // Activity successfully deleted
//                                         // final snackBar = SnackBar(
//                                         //   elevation: 0,
//                                         //   behavior: SnackBarBehavior.floating,
//                                         //   backgroundColor: Colors.transparent,
//                                         //   content: AwesomeSnackbarContent(
//                                         //     title:
//                                         //         'Yap Activity deleted success! ${activity.name}',
//                                         //     message: '',
//                                         //     contentType: ContentType.success,
//                                         //   ),
//                                         // );
//                                         // ScaffoldMessenger.of(context)
//                                         //   ..hideCurrentSnackBar()
//                                         //   ..showSnackBar(snackBar);
//                                         Get.to(Planingtest());
//                                         print(response.statusCode);
//                                         setState(() {
//                                           // Update the state of the widget
//                                           _isLoading = true;
//                                         });
//                                       } else {
//                                         // Error occurred while deleting activity
//                                         print('${response.statusCode} 123');
//                                       }
//                                     }

//                                     // Perform delete action
//                                   } else if (value == 'update') {
//                                     Get.to(updateActivityScreen(
//                                         activity: activity,
//                                         touristGuideid:
//                                             widget.touristGroup!.id));
//                                     // Perform update action
//                                   } else if (value == 'Categories') {
//                                     Get.to(AddActivityTempScreen());
//                                     // Perform update action
//                                   } else if (value == 'Add new planning') {
//                                     Get.to(AddPlanningScreen());
//                                     // Perform update action
//                                   } else if (value == 'Add new Activity') {
//                                     // Get.to(AddActtivityForm(activity: activity));
//                                     String ref = Get.to(AddActivityScreen(
//                                         touristGroup: widget.touristGroup,
//                                         planning: widget.planning)) as String;
//                                     if (ref == 'r') {
//                                       setState(() {
//                                         _isLoading = true;
//                                         changedata();
//                                       });
//                                     }
//                                   }
//                                 },
//                                 icon: Icon(Icons.more_vert),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
// //                     Container(
// //                       color: activity.activityTemplate!.primaryColor != null
// //                           ? Color(int.parse(activity.activityTemplate!.primaryColor!.substring(1),
// //                                   radix: 16))
// //                               .withOpacity(0.2)
// //                           : Color.fromARGB(255, 14, 197, 197),
// //                       height: Get.height * 0.1,
// //                       // padding: const EdgeInsets.all(2),
// //                       alignment: Alignment.center,
// //                       child: ListTile(
// //                         onTap: () {
// //                           print(index);
// //                           Get.to(activitydetalSecreen(activity, token));
// //                         },
// //                         leading: GestureDetector(
// //                           onLongPress: () {
// //                             // Add your function here
// //                             Get.to(UploadScreen(activity));
// //                           },
// //                           child: Container(
// //                             clipBehavior: Clip.hardEdge,
// //                             height: 80,
// //                             decoration:
// //                                 const BoxDecoration(shape: BoxShape.circle),
// //                             child: SizedBox(
// //                               height: 80,
// //                               width: 40,
// //                               child: Image.network(
// //                                 '${baseUrls}/api/activities/uploads/${activity.logo}',
// //                                 headers: {
// //                                   'Authorization': 'Bearer $token',
// //                                 },
// //                                 fit: BoxFit.fitWidth,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         title: Text(
// //                           activity.name?.toString() ?? 'N/A',
// //                           style: TextStyle(
// //                             fontSize: 24,
// //                             height: 0,
// //                             fontStyle: FontStyle.italic,
// //                           ),
// //                         ),
// //                       ),

// // //  ListTile(
// // //                   onTap: () {
// // //                     print(index);

// // //                     Get.to(activitydetalSecreen(activity, token));
// // //                   },
// // //                   title: Text(
// // // // activity.title
// // //                       activity.name?.toString() ?? 'N/A',
// // //                       style: TextStyle(
// // //                           fontSize: 24,
// // //                           height: 0,
// // //                           fontStyle: FontStyle.italic)),
// // // leading: SizedBox(
// // //                     width: 80,
// // //                     height: 80,
// // //                     child: Stack(
// // //                       children: [
// // //                        for (var url in activity.images ?? [])
// // //                           Positioned.fill(
// // //                             child: ClipOval(
// // //                               child: Image.network(
// // //                                 'http://192.168.1.23:3000/api/activities/uploads/$url',
// // //                                 headers: {
// // //                                   'Authorization': 'Bearer $token',
// // //                                 },
// // //                                 fit: BoxFit.cover,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   leading: Container(
// // //                       clipBehavior: Clip.hardEdge,
// // //                       height: 80,
// // //                       //  alignment: Alignment.center,
// // // // width:80,
// // //                       decoration: const BoxDecoration(shape: BoxShape.circle),
// // //                       child: GestureDetector(
// // //                         onLongPress: () {
// // //                           // Add your function here
// // //                           Get.to(UploadScreen(activity:activity));
// // //                         },
// // //                         child: SizedBox(
// // //                           height: 80,
// // //                           width: 40,
// // //                           child: Image.network(
// // //                               'http://192.168.1.23:3000/api/activities/img/${activity.logo}',
// // //                               headers: {
// // //                                 'Authorization': 'Bearer $token',
// // //                               },
// // //                               fit: BoxFit.fitWidth
// // //                               //     .cover, // or BoxFit.fill, BoxFit.fitWidth, BoxFit.fitHeight, etc.
// // //                               ),
// // //                         ),
// // //                       )),
// // //                 ),
// // //               ),
// //                     ),
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         side: BorderSide(
//                           color: activity.activityTemplate!.primaryColor != null
//                               ? Color(int.parse(
//                                       activity.activityTemplate!.primaryColor!
//                                           .substring(1),
//                                       radix: 16))
//                                   .withOpacity(0.5)
//                               : Color.fromARGB(255, 14, 197, 197),
//                           width: 2,
//                         ),
//                       ),
//                       color: activity.activityTemplate!.primaryColor != null
//                           ? Color(int.parse(
//                                   activity.activityTemplate!.primaryColor!
//                                       .substring(1),
//                                   radix: 16))
//                               .withOpacity(0.2)
//                           : Color.fromARGB(255, 14, 197, 197),
//                       child: ListTile(
//                         onTap: () {
//                           print(index);
//                           Get.to(activitydetalSecreen(activity, token));
//                         },
//                         leading: GestureDetector(
//                           onLongPress: () {
//                             // Add your function here
//                             // Get.to(UploadScreen(activity));
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FileUploadScreen(
//                                   dynamicPath: 'Mobile/picture',
//                                   id: activity.id ?? "",
//                                   fild: 'logo',
//                                   object: "api/activities",
//                                 ), // Replace with your dynamic path
//                               ),
//                             );
//                           },
//                           child: Container(
//                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                             height: 200, // Set the desired height for the image
//                             decoration: BoxDecoration(shape: BoxShape.circle),
//                             child: Image.network(
//                               '${baseUrls}/api/activities/uploads/${activity.logo}',
//                               headers: {
//                                 'Authorization': 'Bearer $token',
//                               },
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           activity.name?.toString() ?? 'N/A',
//                           style: TextStyle(
//                             fontSize: 24,
//                             height: 0,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ),
//                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       children: [SizedBox(width: 20,),
// //                         Column(
// //                           children: [
// //                             Text(
// //                               "${DateFormat(' kk:mm ').format(DateTime.now())}  ${DateFormat('- kk:mm ').format(DateTime.now())}",
// //                               style: const TextStyle(fontSize: 14),
// //                             ),
// //                             Text(
// //                               "${DateFormat(' kk:mm ').format(DateTime.now())}  ${DateFormat('- kk:mm ').format(DateTime.now())}",
// //                               style: const TextStyle(fontSize: 14),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(width: 180),
// // // IconButton(
// // //                     // splashRadius: 20,
// // //                     // iconSize: 12,
// // //                     color: Color.fromARGB(255, 175, 10, 10),
// // //                     onPressed: () {
// // //                       // _animationController.reset();
// // //                       // _animationController.forward();
// // //                     },
// // //                     icon: Icon(Icons.mode_edit),
// // //                   ),

// // //                   Text(
// // //                     'Modifie',
// // //                     style: TextStyle(color: Colors.black),
// // //                   ),

// //                         // DropdownButton<String>(
// //                         //   value: selectedOption,
// //                         //   items: _options.map((String option) {
// //                         //     return DropdownMenuItem<String>(
// //                         //       value: option,
// //                         //       child: Text(option),
// //                         //     );
// //                         //   }).toList(),
// //                         //   onChanged: (String? newValue) {
// //                         //     setState(() {
// //                         //       print(selectedOption);
// //                         //       selectedOption = newValue!;

// //                         //       print(newValue);
// //                         //     });
// //                         //   },
// //                         // ),

// //                         // ElevatedButton(
// //                         //   onPressed: () {
// //                         //     // Do something when the button is pressed
// //                         //     Get.to(ActivityEditScreen(activity));

// //                         //     // logout();
// //                         //   },
// //                         //   style: ElevatedButton.styleFrom(
// //                         //     primary: Color.fromARGB(255, 209, 204, 204)
// //                         //     onPrimary: Colors.black,
// //                         //   ),
// //                         //   child: Row(
// //                         //     children: [
// //                         //       Icon(Icons.mode),
// //                         //       SizedBox(width: 8),
// //                         //       Text(
// //                         //         'status',
// //                         //         style: TextStyle(color: Colors.black),
// //                         //       ),
// //                         //     ],
// //                         //   ),
// //                         // ),
// //                         // DropdownButton(
// //                         //   items: _dropDownItem(),
// //                         //   onChanged: (value) {
// //                         //     setState(() {
// //                         //       print('${index} and ${value}');
// //                         //     });
// //                         //   },
// //                         //   value: selectedItemValue[3],
// //                         //   hint: Text('0'),
// //                         // ),
// // //this what i will use with api
// //                         SizedBox(width: 2),
// //                       ],
// //                     ),

//                     const Divider(
//                       color: Color.fromARGB(47, 0, 0, 0),
//                       indent: 8,
//                       endIndent: 8,
//                       thickness: 1.5,
//                     ),
//                     SizedBox(
//                       height: 14,
//                     ),
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(width: 20),
//                             Text(
//                               "france tunisia",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w200,
//                               ),
//                             ),
//                             SizedBox(width: 40),
//                             Text(
//                               "france tunisia",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w200,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             SizedBox(width: 24),
//                             Text(
//                               "${DateFormat('EEE, MMM d').format(DateTime.now())}",
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 40),
//                             Text(
//                               "${DateFormat('EEE, MMM d').format(DateTime.now())}",
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         const Divider(
//                           color: Color.fromARGB(47, 0, 0, 0),
//                           indent: 8,
//                           endIndent: 8,
//                           thickness: 1.5,
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Row(
//                           children: [
//                             const SizedBox(width: 16),
//                             Text(
//                               "ASl France",
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 20),
//                             Icon(Icons.account_box),
//                             IconButton(
//                               icon: Icon(Icons.map),
//                               onPressed: () async {
//                                 final activityTemplate =
//                                     activity.activityTemplate;
//                                 if (activityTemplate != null &&
//                                     activityTemplate.coordinates != null) {
//                                   final coordinates =
//                                       activityTemplate.coordinates!;
//                                   final binaryCoordinates =
//                                       jsonEncode(coordinates);
//                                   final parsedCoordinates =
//                                       parseCoordinates(binaryCoordinates);
//                                   final latitude = parsedCoordinates[0];
//                                   final longitude = parsedCoordinates[1];
//                                   final placeQuery = '$latitude $longitude';
//                                   final c = Colors.blue;
//                                   openMapApp(
//                                     latitude,
//                                     longitude,
//                                     placeQuery: placeQuery,
//                                     trackLocation: true,
//                                     color: c,
//                                     markerImage:
//                                         const AssetImage('assets/Male.png'),
//                                     map_action: true,
//                                   );
//                                   // final placemarks =
//                                   //     await placemarkFromCoordinates(
//                                   //         latitude, longitude);
//                                   // final placeName = placemarks.first.name ?? '';

//                                   // Use the place name as desired
//                                   // print('Place Name: $placeName');
//                                   print(
//                                       'Binary Coordinates: $binaryCoordinates');
//                                   print('Latitude: $latitude');
//                                   print('Longitude: $longitude');
//                                 }
// //                                 final coordinates =
// //                                     activity.activityTemplate?.coordinates!;
// //                                  final binaryCoordinates =
// //                                      jsonEncode(coordinates);
// // final parsedCoordinates =
// //                                     parseCoordinates(binaryCoordinates);
// //                                  final latitude = parsedCoordinates[0];
// //                                  final longitude = parsedCoordinates[1];
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => MapWidget(
// //                                       latitude: latitude,
// //                                       longitude: longitude,
//                                 // ),
//                                 //   // ),
//                                 // );
//                               },
//                             ),
//                             Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.comment),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             CommentScreen(activity: activity),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 Text(
//                                   " Comments..",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const Divider(
//                           color: Color.fromARGB(47, 0, 0, 0),
//                           indent: 8,
//                           endIndent: 8,
//                           thickness: 1.5,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }

// Build the tab bar with a tab for each day in the date range
  TabBar buildTabBar(DateTime startDate, DateTime endDate) {
    final List<Tab> tabs = [];
    final List<Widget> tabViews = [];

    for (var date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
// .add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      tabs.add(Tab(text: DateFormat('EEE, MMM d').format(date)));
      tabViews.add(_buildTabView(date.add(Duration(days: 1))));
    }

    return TabBar(
      tabs: tabs,
      isScrollable: true,
      indicatorColor: Color.fromARGB(255, 51, 33, 243),
      labelColor: Color.fromARGB(255, 255, 255, 255),
      unselectedLabelColor: Color.fromARGB(255, 8, 0, 0),
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
      labelPadding: EdgeInsets.symmetric(horizontal: 16),
      onTap: (index) {},
    );
  }
}

List<DateTime> getRangeOfDates(DateTime startDate, DateTime endDate) {
  final List<DateTime> dates = [];

  for (var date = startDate;
      date.isBefore(endDate);
      date = date.add(Duration(days: 1))) {
    dates.add(date);
  }

  // Add the end date to the list
  dates.add(endDate);

  return dates;
}

void _showMenu(BuildContext context) {
  final Color primary = Color.fromARGB(222, 255, 255, 255);
  final Color active = Color.fromARGB(237, 243, 239, 239);
  final Color active1 = Color.fromARGB(255, 255, 254, 254);
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final RenderBox? button = context.findRenderObject() as RenderBox?;
  final Offset position = button!.localToGlobal(Offset.zero, ancestor: overlay);
  double screenHeight = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    backgroundColor: Color.fromARGB(0, 223, 31, 31),
    isScrollControlled: true,
    builder: (BuildContext context) {
      AnimationController _animationController = AnimationController(
        vsync: Navigator.of(context),
        duration: Duration(milliseconds: 500),
      );
      final Size size = MediaQuery.of(context).size;
      _animationController.forward();

      return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Container(
            child: Transform(
              transform: Matrix4.translationValues(
                  -size.width * (1 - _animationController.value), 0, 0),
              child: Container(
                color: Color.fromARGB(0, 21, 37, 214),
                height: MediaQuery.of(context).size.height - 80,
                child: ClipPath(
                  clipper: OvalRightBorderClipper(),
                  child: Drawer(
                    child: Container(
                      padding: const EdgeInsets.only(left: 26.0, right: 200),
                      decoration:
// BoxDecoration(
//                         color: primary,
//                         boxShadow: [BoxShadow(color: Color.fromARGB(193, 0, 0, 0))],
//                       ),
                          BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(212, 200, 3, 49),
                            Color.fromARGB(253, 41, 2, 167)
                          ],
                        ),
                      ),
                      width: 200,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 28.0),
                              Container(
                                height: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: [
                                      Colors.orange,
                                      Colors.deepOrange
                                    ])),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainProfile()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        4.0), // Adjust the padding values as needed
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(225, 255, 255, 255),
                                    ),
                                    child: selectedUser?.picture == null
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: Image.network(
                                              'https://st4.depositphotos.com/15648834/23779/v/450/depositphotos_237795804-stock-illustration-unknown-person-silhouette-profile-picture.jpg',
                                              fit: BoxFit.cover,
                                            ).image,
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: Image.network(
                                              '${baseUrls}/assets/uploads/Mobile/picture/${selectedUser?.picture}',
                                              fit: BoxFit.cover,
                                            ).image,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),

                              ListTile(
                                leading: Icon(Icons.person_pin, color: active1),
                                subtitle: Text('${selectedUser?.lastName}',
                                    style: TextStyle(
                                        color: active1,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                title: Text('Welcome :',
                                    style: TextStyle(
                                        color: active1,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)),
                                onTap: () {
                                  // Navigate to home screen
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => PlanningListPage()),
                                  // );
                                },
                              ),
                              SizedBox(height: 16.0),
                              ListTile(
                                leading: Icon(Icons.home, color: active),
                                title: Text('Home',
                                    style: TextStyle(color: active)),
                                onTap: () {},
                              ),
                              _buildDivider(),
                              ListTile(
                                leading:
                                    Icon(Icons.qr_code_scanner, color: active),
                                title: Text('QRScanner',
                                    style: TextStyle(color: active)),
                                onTap: () {
                                  // Get.to(QrScanner());
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading:
                                    Icon(Icons.list_alt_sharp, color: active),
                                title: Text('My ACtivity Template',
                                    style: TextStyle(color: active)),
                                onTap: () {
                                  // Get.to(AddActivityTempScreen());
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(Icons.groups, color: active),
                                title: Text('Add Activity Template ',
                                    style: TextStyle(color: active)),
                                onTap: () {
                                  // Get.to(AddActivityTScreen());
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading:
                                    Icon(Icons.notification_add, color: active),
                                title: Text('Push Notification',
                                    style: TextStyle(color: active)),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           PushNotificationScreen()),
                                  // );
                                },
                              ),
                              _buildDivider(),

                              ListTile(
                                trailing: Icon(Icons.more, color: active),
                                title: Text('Accommodation && Transfers ',
                                    style: TextStyle(color: active)),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => HomePage()),
                                  // );
                                  // Get.to(AllDataAScreen(planningid));
                                },
                                onLongPress: () {
                                  // Get.to(AddHotel());
                                  // Get.to(PushNotificationScreen());
                                },
                              ),

                              /// ---------------------------
                              /// last Item for drawer
                              /// ---------------------------

                              _buildDivider(),
                              SizedBox(height: 40.0),
                              Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 35, 2, 143),
                                          Color.fromARGB(255, 98, 1, 1)
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                            leading: Icon(Icons.person,
                                                size: 30,
                                                color: Color.fromARGB(
                                                    255, 2, 44, 160)),
                                            title: Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontFamily: 'Bahij Janna',
                                                fontWeight: FontWeight.w900,
                                                fontSize: 10,
                                                color: Color.fromARGB(
                                                    255, 237, 226, 226),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            trailing: Icon(
                                                Icons.logout_outlined,
                                                size: 20,
                                                color: Colors.red),
                                            onTap: () async {
                                              await storage.delete(
                                                  key: "access_token");
                                              // await FacebookAuth.instance.logOut();
                                              // _accessToken = null;
                                              // Get.to(LoginView());
                                            }),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                              .padding
                                              .bottom,
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Divider _buildDivider() {
  final Color divider = Colors.deepOrange;
  return Divider(
    color: divider,
  );
}

Future<String> readRoleFromToken(String data) async {
  String? token = await storage.read(key: "access_token");
  Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
  data = decodedToken['$data'];

  return data;
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width * (2 / 3) - 20, 0);
    path.quadraticBezierTo(size.width * (2.2 / 3), size.height / 4,
        size.width * (2.2 / 3), size.height / 2);
    path.quadraticBezierTo(
        size.width * (2.2 / 3),
        size.height - (size.height / 4),
        size.width * (2 / 3) - 20,
        size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
