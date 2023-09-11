import 'package:flutter/material.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import '../../modele/httpNotificationId.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String? id;

  const ActivityDetailScreen({super.key, this.id});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  // ignore: non_constant_identifier_names
  final NotificationH =
      HTTPHandlerNotificationId(); // Initialize your HTTP handler
  late PushNotification activityDetails;
  String? ids;
  @override
  void initState() {
    super.initState();
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
    fetchActivityDetails(ids);
  }

  Future<PushNotification> fetchActivityDetails(String? id) async {
    try {
      final details =
          await NotificationH.fetchData("/api/push-notificationsMobile/$ids");

      return details; // Return the fetched data
    } catch (error) {
      rethrow; // You should throw the error to propagate it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCFCFDB),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(width: 40),
            const Text(
              'Notification Detail',
              style: TextStyle(
                color: Color(0xFF440596),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Add a background gradient
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 180, 212, 238),
              Color.fromARGB(255, 130, 146, 238)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: FutureBuilder<PushNotification>(
            future: fetchActivityDetails(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final details = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display notification icon and additional details here
                    // Apply custom fonts, styles, and animations as needed
                    Text(
                      details!.title as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 15, 243),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 22.0),
                    Text(
                      details.type ?? 'No Data',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 67, 21, 233),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Text(
                      details.message ?? 'No Data',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Add buttons or actions for user interaction
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
