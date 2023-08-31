import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_trip/Secreens/guide_Screens/travelers_list_screen.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';

// Import your tourist group model

class TravellersListScreen extends StatefulWidget {
  final String? guideId;

  TravellersListScreen({required this.guideId});

  @override
  _TravellersListScreenState createState() => _TravellersListScreenState();
}

class _TravellersListScreenState extends State<TravellersListScreen> {
  List<TouristGroup> _touristGroups = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tourist-groups/touristGuideId/${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      _touristGroups =
          results.map((groupData) => TouristGroup.fromJson(groupData)).toList();
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
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
              "Travellers List",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _touristGroups.length,
        itemBuilder: (context, index) {
          final group = _touristGroups[index];

          return Card(
            elevation: 4, // Adjust the elevation for shadow effect
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

            child: ListTile(
              title: Text(
                group.name ?? "N/A",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Group ID: ${group.id}",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              // You can add more content here like trailing icons, etc.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravelersListScreen(
                      selectedtouristGroupId: group.id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
