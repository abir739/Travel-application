import 'package:flutter/material.dart';

import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';

class NotificationScreen extends StatelessWidget {
  String? groupsid;
  NotificationScreen({required this.groupsid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications ${groupsid}'),
      ),
          body: NotificationList(groupsid: groupsid),
    );
  }
}

class NotificationList extends StatefulWidget {
  @override
String? groupsid;
  NotificationList({required this.groupsid});
  _NotificationListState createState() => _NotificationListState();
}


class _NotificationListState extends State<NotificationList> {
  final httpHandler = HTTPHandlerPushNotification();
  final count = HTTPHandlerCount();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PushNotification>>(
      future: httpHandler.fetchData(
          '/api/push-notificationsMobile?filters[tagsGroups]=${widget.groupsid}'), // Replace with your API endpoint
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No notifications available.'));
        } else {
          // Display the list of notifications
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data![index];
              return ListTile(
                title: Text(notification.title ?? "title"),
                subtitle: Text(notification.message ?? "message"),
             

              );
            },
          );
        }
      },
    );
  }
}
