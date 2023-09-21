import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  String? groupsid;
  NotificationScreen({required this.groupsid});
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
                'Notifications ',
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
  int limit = 6;
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
                final notificationsList = ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data!.length) {
                      // This is the last item, add the "See Fewer Notifications" GestureDetector
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle the click event for "See Fewer Notifications"
                            setState(() {
                              limit = limit + 6;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "See Fewer Notifications",
                              style: TextStyle(
                                color: Color(0xFF3A3557),
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final notification = snapshot.data![index];

                    final formattedDate = dateFormat
                        .format(notification.createdAt ?? DateTime.now());

                    final formattedTime = timeFormat
                        .format(notification.createdAt ?? DateTime.now());

                    final creatorUserId = notification.creatorUserId ?? '';
                    final title = notification.title ?? '';
                    final message = notification.message ?? '';

                    final bool isDifferentDate = index == 0 ||
                        formattedDate !=
                            dateFormat.format(
                                snapshot.data![index - 1].createdAt ??
                                    DateTime.now());

                    return Column(
                      children: [
                        if (isDifferentDate)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical:
                                14, // Increase vertical margin for more height
                            horizontal: 16,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                14), // Add padding to increase card size
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius:
                                      30, // Adjust the radius to make the image larger
                                  backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2NKsAR38L2Nsk1q1H_u3EWO_oo9ggQwYXig&usqp=CAU",
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add space between CircleAvatar and content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(title,
                                          style: const TextStyle(
                                              fontSize:
                                                  18)), // Increase title font size
                                      Text(creatorUserId,
                                          style: TextStyle(fontSize: 12)),
                                      Text(message),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatTimestamp(notification.createdAt),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return notificationsList; // Add this return statement
              }

              // Add a default return statement (can be an empty container or a CircularProgressIndicator)
              // return Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}
