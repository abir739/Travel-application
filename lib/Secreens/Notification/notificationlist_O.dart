import 'package:flutter/material.dart';
import 'package:zenify_trip/Secreens/Notification/NotificationDetails.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../Transfer/transferdetailsfromnotification.dart';

class NotificationScreen extends StatelessWidget {
  String? groupsid;
  NotificationScreen({required this.groupsid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  int limit = 12;
  String formatTimestamp(DateTime? dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: Color.fromARGB(255, 238, 227, 227),
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              // Implement your refresh logic here
              await Future.delayed(
                  Duration(microseconds: 200)); // Simulate a delay
              setState(() {}); // Trigger a rebuild of the widget
            },
            child: FutureBuilder<List<PushNotification>>(
              future: httpHandler.fetchData(
                  '/api/push-notificationsMobile?filters[tagsGroups]=${widget.groupsid}&limit=$limit'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notifications available.'));
                } else {
                  final dateFormat = DateFormat('MMMM d, yyyy');
                  final timeFormat = DateFormat('hh:mm a');
                  // Display the list of notifications
                  final notificationsList = ListView.separated(
                    itemCount: snapshot.data!.length +
                        1, // Add 1 for "See Fewer Notifications"
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length) {
                        // This is the last item, add the "See Fewer Notifications" GestureDetector
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Handle the click event for "See Fewer Notifications"
                                  setState(() {
                                    limit = limit + 6;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "See Fewer Notifications",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final notification = snapshot.data![index];

                      // Format the notification's createdAt date
                      final formattedDate = dateFormat
                          .format(notification.createdAt ?? DateTime.now());

                      // Format the notification's createdAt time
                      final formattedTime = timeFormat
                          .format(notification.createdAt ?? DateTime.now());

                      // Check if the current notification's date is different from the previous one
                      final bool isDifferentDate = index == 0 ||
                          formattedDate !=
                              dateFormat.format(
                                  snapshot.data![index - 1].createdAt ??
                                      DateTime.now());

                      return Column(
                        children: [
                          if (isDifferentDate)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                formattedDate, // Use the formatted date
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              // Handle the click event for "See Fewer Notifications"
                              // setState(() {
                              // limit = limit + 6;
                              print(notification.type);
                              Get.to(ActivityDetailScreen(
                                  notification: notification));
                              // });
                            },
                            child: Chip(
                              avatar: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2NKsAR38L2Nsk1q1H_u3EWO_oo9ggQwYXig&usqp=CAU"),
                              ),
                              label: ListTile(
                                title: Text(notification.title ?? "title"),
                                trailing: notification.type == "Transfer"
                                    ? Column(
                                        children: [
                                          Text("🚍 "),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            formatTimestamp(
                                                notification.createdAt),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ],
                                      )
                                    : Text(
                                        formatTimestamp(notification.createdAt),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                subtitle: Text(
                                  notification.message ?? "Message",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                //  Text(
                                //                               "${notification.message ?? "message"}\n$formattedTime", // Include formatted time
                                //                             ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      // This function defines the separators between items.
                      // You can return a widget that represents the separator.
                      return Divider(
                        endIndent: Get.width * 0.2,
                        indent: Get.width * 0.2,
                        height:
                            5, // Adjust the height of the separator as needed
                        thickness: 2,
                        color: Color.fromARGB(80, 18, 2,
                            160), // Customize the color of the separator
                      );
                    },
                  );

                  return notificationsList;
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
