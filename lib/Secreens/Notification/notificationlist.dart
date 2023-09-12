import 'package:flutter/material.dart';

import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';


class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: NotificationList(), // Display the list of notifications
    );
  }
}

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final httpHandler = HTTPHandlerPushNotification();
final count = HTTPHandlerCount();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PushNotification>>(
      future: httpHandler.fetchData(
          '/api/push-notificationsMobile?filters[tags]=7ac6a6e6-13c2-418d-9504-b6c76c028fb6'), // Replace with your API endpoint
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
trailing: 
               FutureBuilder<int>(
                                  future: count.fetchInlineCount(
                                    "/api/push-notificationsMobile?filters[tags]=7ac6a6e6-13c2-418d-9504-b6c76c028fb6",
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while fetching the inline count
                                      return CircularProgressIndicator(
                                          strokeWidth: 1.0);
                                    }
                                    if (snapshot.hasError) {
                                      // Handle the error if the inline count couldn't be fetched
                                      return Text("Error");
                                    }
                                    final inlineCount = snapshot.data ?? 0;
                                    return Text(
                                      " $inlineCount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                    );
                                  },
                                ),
                    //           ],
                    //         ),
                    // ),

                // Customize the UI for each notification as needed
              );
            },
          );
        }
      },
    );
  }
}
