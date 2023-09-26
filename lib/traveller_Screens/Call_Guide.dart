import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';

class TouristGuideProfilePage extends StatefulWidget {
  Traveller? traveller;

  TouristGuideProfilePage({Key? key, this.traveller}) : super(key: key);

  @override
  _TouristGuideProfilePageState createState() =>
      _TouristGuideProfilePageState();
}

class _TouristGuideProfilePageState extends State<TouristGuideProfilePage> {
  List<TouristGroup> _touristGroups = [];
  TouristGuide? touristGuide; // Declare touristGuide at the class level
  User? user;
  bool loading = false;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      fetchData();
      setState(() {
        dataLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    fetchData();
    super.dispose();
  }

  Future<void> fetchDataUser(String id, String? token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrls/api/users/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(userData);
        });
   // Assuming you have a User.fromJson constructor
      } else {
        print("Error fetching user data: Response was not 200");
        // Handle error here
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle error here
    }
  }

  Future<void> fetchData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    // Fetch the selected tourist group
    String url = formatter(
        "$baseUrls/api/tourist-groups/8d55d871-1b6c-4584-9ece-ee645e64c09c");

    final touristGroupResponse = await http.get(
      Uri.parse(
          "$baseUrls/api/tourist-groups/8d55d871-1b6c-4584-9ece-ee645e64c09c"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    // Fetch the selected tourist group
    print("${touristGroupResponse.body}");
    if (touristGroupResponse.statusCode == 200) {
      final touristGroupData = jsonDecode(touristGroupResponse.body);
      final touristGuideId = touristGroupData['touristGuideId'];

      print("$touristGuideId touristGuideId");
      // Fetch the tourist guide
      final touristGuideResponse = await http.get(
        Uri.parse('$baseUrls/api/tourist-guides/$touristGuideId'),
        headers: {"Authorization": "Bearer $token"},
      );
      if (touristGuideResponse.statusCode == 200) {
        final touristGuideData = jsonDecode(touristGuideResponse.body);
        final id = touristGuideData['userId'];
        fetchDataUser(id, token);
        touristGuide = TouristGuide.fromJson(
            touristGuideData); // Assign value to touristGuide
      } else {
        print("Error fetching tourist guide profile: Response was not 200");
        // Handle error here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 137, 219),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(width: 30),
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
                'Your Guide Profil',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors
                      .white, // You can adjust the font size and color here
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: dataLoaded
            ? Column(
                children: <Widget>[
                  _buildHeader(touristGuide),
                  _buildInfo(context, widthC, user),
                  _buildMainInfo(context, widthC, user),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildHeader(TouristGuide? touristGuide) {
    if (touristGuide?.id != null) {
      // Return a loading indicator or placeholder
      return CircularProgressIndicator();
    }
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://img.freepik.com/free-vector/travel-time-typography-design_1308-90406.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 140),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Colors.grey.shade500,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white,
                      width: 6.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        touristGuide?.user?.picture ??
                            ''
                                'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfo(BuildContext context, double width, User? user) {
    if (user?.id != null) {
      // Return a loading indicator or placeholder
      return CircularProgressIndicator();
    }
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user?.username ?? 'Unknown Username', // Fallback value if null
            style: TextStyle(
              color: Colors.grey.shade50,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context, double width, User? user) {
    if (user != null) {
      // Return a loading indicator or placeholder
      return CircularProgressIndicator();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("E-Mail"),
                subtitle: Text(user?.email ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Phone Number"),
                subtitle: GestureDetector(
                  onTap: () {
                    _launchPhoneCall(user?.phone);
                  },
                  child: Text(
                    user?.phone ?? 'N/A',
                    style: const TextStyle(
                      color: Colors
                          .blue, // Make the phone number blue to indicate it's tappable
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cake,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Birth Date"),
                subtitle: Text(
                  user?.birthDate?.toString() ?? 'N/A',
                ),
              ),
              const Divider(),
              ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: Color.fromARGB(255, 94, 36, 228),
                  ),
                  title: const Text("Able to speak:"),
                  subtitle: Text(
                    '${user?.languageId ?? ''}\n ${user?.secondLanguageId ?? ''}',
                  )),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: const Icon(
                  Icons.my_location,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Location"),
                subtitle: Text(user?.address ?? 'N/A'),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      // TODO: Call the user
                      Uri phoneno = Uri.parse('tel:${user?.phone}');
                      if (await launchUrl(phoneno)) {
                        //dialer opened
                      } else {
                        //dailer is not opened
                      }
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      // TODO: Send email to the user
                      String email = Uri.encodeComponent(user?.email ?? '');

                      String subject =
                          Uri.encodeComponent("Hello ${user?.firstName}");
                      String body = Uri.encodeComponent(
                          "Hi! I'm Traveller in  your Group for the Trip");
                      print(subject); //output: Hello%20Flutter
                      Uri mail = Uri.parse(
                          "mailto:$email?subject=$subject&body=$body");
                      if (await launchUrl(mail)) {
                        //email app opened
                      } else {
                        //email app is not opened
                      }
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Icon(
                        Icons.messenger,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      // TODO: Send message to the user
                      Uri sms =
                          Uri.parse('sms:${user?.phone}?body=your text here');
                      if (await launchUrl(sms)) {
                        //app opened
                      } else {
                        //app is not opened
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to launch a phone call
void _launchPhoneCall(String? phoneNumber) async {
  if (phoneNumber != null && await canLaunch("tel:$phoneNumber")) {
    await launch("tel:$phoneNumber");
  } else {
    // Handle the case where the phone number is not valid or cannot be launched.
    // You can display a message to the user in this case.
    print("Cannot launch phone call to $phoneNumber");
  }
}
