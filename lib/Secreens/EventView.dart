import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/Secreens/AccomodationSecreen/AccomodationDetail.dart';
import '../modele/accommodationsModel/accommodationModel.dart';
import '../modele/activitsmodel/activitesmodel.dart';

import '../modele/transportmodel/transportModel.dart';

import 'Activity/activitytempdetails.dart';
import 'Transfer/transferdetails.dart';

class EventView extends StatefulWidget {
  final Transport event; // Replace with your event class
  EventView({required this.event});

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
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    print(token);
    print(widget.event);
    tokens = token;
    return token;
  }

  @override
  Widget build(BuildContext context) {
    print(getAccessToken);
    print(widget.event);
    return Scaffold(
        body: FutureBuilder<String>(
      // Check the event type
      future: checkEventType(widget.event),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String eventType = snapshot.data ?? 'Unknown';
          if (eventType == 'Transport') {
            return TransportSecreen(widget.event as Transport?, tokens);
          } else if (eventType == 'Activity') {
            return activitytempdetalSecreen(widget.event as Activity?, tokens);
          } else if (eventType == 'Accommodations') {
            return accomodationDetailsSecreen(
                widget.event as Accommodations?, tokens);
          } else {
            return Text(widget.event.toString() ?? 'No id');
          }
        }
      },
    )
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

  Future<String> checkEventType(dynamic eventType) async {
    if (eventType is Transport) {
      return 'Transport';
    } else if (eventType is Activity) {
      return 'Activity';
    } else if (eventType is Accommodations) {
      return 'Accommodations';
    } else {
      return 'Unknown';
    }
  }

}
