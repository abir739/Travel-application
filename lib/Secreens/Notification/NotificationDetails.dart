import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';

import '../../modele/activitsmodel/pushnotificationmodel.dart';
import '../../modele/httpNotificationId.dart';
import '../../modele/httpTouristguidByid.dart';
import '../../modele/httpTravellerbyid.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String? id;

  const ActivityDetailScreen({this.id});

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final NotificationH =
      HTTPHandlerNotificationId(); // Initialize your HTTP handler
  late PushNotification activityDetails;
  String? ids;
  @override
  void initState() {
    super.initState();
    // final Map<String, dynamic>? arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ids    = arguments?['id'] as String?;
    // // Fetch activity details using the provided ID
    // print("${widget.id} widget.id" );
    // fetchActivityDetails(ids);
    // final Map<String, dynamic>? arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ids = arguments?['id'] as String?;
    // print("ids $ids");
    // Fetch activity details using the extracted 'id'
    fetchActivityDetails(ids);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract the 'id' value from the route argumentsR
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    ids = arguments?['id'] as String?;
    print("ids $ids");
    // Fetch activity details using the extracted 'id'
    fetchActivityDetails(ids);
  }

//   Future<PushNotification> fetchActivityDetails(String id) async {
//     try {
//       // Use your HTTP handler to fetch activity details by ID
//       final activityDetails = await NotificationH.fetchData(id);
//       // Update the state or display the activity details here
//     } catch (error) {
//       // Handle any errors or show an error message
//     }
// return activityDetails;
//   }
// Future<void> fetchActivityDetails(String id) async {
//     try {
//       final details = await NotificationH.fetchData(id);
//       setState(() {
//         activityDetails = details as PushNotification;
//       });
//     } catch (error) {
//       // Handle any errors or show an error message
//     }
//   }
  Future<PushNotification> fetchActivityDetails(String? id) async {
    try {
      final details =
          await NotificationH.fetchData("/api/push-notificationsMobile/$ids");

      return details; // Return the fetched data
    } catch (error) {
      // Handle any errors or show an error message
      throw error; // You should throw the error to propagate it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<PushNotification>(
          future: fetchActivityDetails(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While data is being fetched, display a loading indicator
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // Once data is fetched, display the activity details
              final details = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details?.message ?? 'No Data',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Add more widgets here to display additional details if needed
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
