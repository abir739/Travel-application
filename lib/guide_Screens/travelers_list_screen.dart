import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_trip/guide_Screens/TravelerProfileScreen.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/svg.dart';

class TravelersListScreen extends StatefulWidget {
  final String? selectedtouristGroupId;

  const TravelersListScreen({super.key, required this.selectedtouristGroupId});

  @override
  _TravelersListScreenState createState() => _TravelersListScreenState();
}

class _TravelersListScreenState extends State<TravelersListScreen> {
  List<Traveller> _travelers = [];

  @override
  void initState() {
    super.initState();
    fetchTravelersData();
  }

  Future<void> fetchTravelersData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter(
        "/api/travellers?filters[touristGroupId]=${widget.selectedtouristGroupId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> results = responseData["results"];
      final List<Traveller> fetchedTravellers =
          results.map((data) => Traveller.fromJson(data)).toList();
      setState(() {
        _travelers = fetchedTravellers;
      });
    } else {
      print("Error fetching travelers data: ${response.statusCode}");
      // Handle error here
    }
  }

  void _navigateToProfile(Traveller traveler) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TravelerProfileScreen(traveler: traveler),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 40),
            const Text(
              "Travelers List",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 5.0),
              const SizedBox(width: 32.5),
              Container(
                height: 40.0,
                width: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEB5F52),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFEB5F52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Add user screen navigation logic here
                  },
                  child: const Center(
                    child: Text(
                      'Add User     ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17.0),
          Expanded(
            child: ListView.builder(
              itemCount: _travelers.length,
              itemBuilder: (context, index) {
                final traveler = _travelers[index];

                return GestureDetector(
                  onTap: () {
                    _navigateToProfile(traveler); // Navigate to profile screen
                  },
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Call',
                          backgroundColor:
                              const Color.fromARGB(255, 27, 97, 39),
                          icon: Icons.phone,
                          onPressed: (context) async {
                            Uri phoneNumber =
                                Uri.parse('tel:${traveler.user!.phone}');
                            if (await launchUrl(phoneNumber)) {
                              //dialer opened
                            } else {
                              //dailer is not opened
                            }
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            // Handle delete action
                            setState(() {
                              _travelers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    child: Card(
                      elevation:
                          4, // Add some elevation for a card-like appearance
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8), // Adjust margins
                      child: Padding(
                        padding: const EdgeInsets.all(
                            12), // Add padding to the card's content
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: traveler.user!.picture != null
                                ? NetworkImage("${traveler.user!.picture}")
                                : null, // Use null if there is no picture
                            radius:
                                40, // Increase the radius for a bigger profile picture
                            child: traveler.user!.picture == null
                                ? Text(
                                    '${traveler.user!.firstName?[0]}${traveler.user!.lastName?[0]}',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ) // Display initials if no picture
                                : null, // Use null if there is a picture
                          ),
                          title: Text(
                            '${traveler.user!.firstName} ${traveler.user!.lastName}',
                            style: const TextStyle(
                                fontSize: 18), // Increase the font size
                          ),
                          subtitle: Text(
                            'ID: ${traveler.id}',
                            style: const TextStyle(
                                fontSize: 14), // Increase the font size
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
