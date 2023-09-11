import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../modele/Event/Event.dart';
import '../modele/activitsmodel/activitesmodel.dart';
import 'Activity/activitytempdetails.dart';

class EventView extends StatefulWidget {
  final CalendarEvent event; // Replace with your event class

  const EventView({super.key, required this.event});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  ScrollController controller = ScrollController();
  String? tokens = '';
  @override
  void initState() {
    super.initState();
    getAccessToken();
  }

  Future<String?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    print(token);
    tokens = token;
    return token;
  }

  @override
  Widget build(BuildContext context) {
    print(getAccessToken);
    print(widget.event.type);
    return Scaffold(
      body: FutureBuilder(
        // Replace with your logic to determine if the event type is Activity
        future: checkIfActivity(widget.event.type),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
            
          } else {
            bool isActivity = snapshot.data ?? false;
            return isActivity
                ? activitytempdetalSecreen(
                    widget.event.type as Activity?, tokens)
                : Text(widget.event.id ?? 'No id');
          }
        },
      ),
    );
  }

  // Replace this with your logic to check if the event type is Activity
  Future<bool> checkIfActivity(dynamic eventType) async {
    if (eventType is Activity) {
      // Implement your logic here to determine if the event type is Activity
      return true;
    }
    return false;
  }

//   Future<String?> getAccessToken() async {
//     final storage = FlutterSecureStorage();
//     final token = await storage.read(key: 'access_token');
//     return token;
//   }
}
