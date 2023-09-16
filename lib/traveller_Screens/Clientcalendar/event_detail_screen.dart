import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenify_trip/guide_Screens/calendar/transfert_data.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class EventDetailScreen extends StatelessWidget {
  final Transport event;

  String calculateDuration(DateTime startTime, DateTime endTime) {
    final Duration difference = endTime.difference(startTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours hours $minutes minutes';
  }

  // Calculate the end time by adding duration to the start time
  DateTime calculateEndTime(DateTime startTime, int? durationHours) {
    if (durationHours != null) {
      return startTime.add(Duration(hours: durationHours));
    } else {
      // Handle the case where durationHours is null (you can provide a default value or handle it as needed)
      // For example, you can return the startTime itself:
      return startTime;
    }
  }

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the end time
    final DateTime endTime =
        calculateEndTime(event.date ?? DateTime.now(), event.durationHours);

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
            const SizedBox(width: 35),
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
                'Transport Details',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: Colors.grey[600],
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Start Time:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMd()
                          .add_jm()
                          .format(event.date ?? DateTime.now()),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Display End Time
                Row(
                  children: [
                    Icon(
                      Icons
                          .access_time_outlined, // You can change the icon as needed
                      color: Colors.grey[600],
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'End Time:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMd().add_jm().format(endTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Direction:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      event.note ?? 'N/A',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[600],
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Duration:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      event.durationHours.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
                // Add your animated photos, icons, or any other widgets here.
                // Example:
                Image.network(
                  'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                  width: 330, // Adjust the width as needed
                  height: 330, // Adjust the height as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
