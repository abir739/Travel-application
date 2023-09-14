import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenify_trip/guide_Screens/calendar/transfert_data.dart';

class EventDetailScreen extends StatelessWidget {
  final TransportEvent event;
  String calculateDuration(DateTime startTime, DateTime endTime) {
    final Duration difference = endTime.difference(startTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours hours $minutes minutes';
  }

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

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
                  color: Colors
                      .white, // You can adjust the font size and color here
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
                          .format(event.startTime ?? DateTime.now()),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: Colors.grey[600],
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'End Time:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat.yMd()
                          .add_jm()
                          .format(event.endTime ?? DateTime.now()),
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
                      event.startTime != null && event.endTime != null
                          ? calculateDuration(event.startTime!, event.endTime!)
                          : 'N/A',
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
