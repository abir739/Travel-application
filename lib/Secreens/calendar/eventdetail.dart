import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:zenify_trip/Secreens/calendar/edit_transport-test.dart';
//import 'package:zenify_trip/Secreens/calendar/edit_transport.dart';
import 'package:zenify_trip/Secreens/calendar/transfert_data.dart';
import 'package:flutter_svg/svg.dart';

import 'edit_transport-test.dart';

class EventView extends StatelessWidget {
  final TransportEvent event; // Assuming you have a TransportEvent class

  EventView({required this.event});

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
            const Text(
              'Event Details',
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Transport Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              'Title: ${event.title}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Start Date: ${event.startTime}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'End Date: ${event.endTime}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Note: ${event.note}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${event.description}',
              style: const TextStyle(fontSize: 18),
            ),
            // Add more details here if needed
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFEB5F52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Navigate to the edit screen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEventScreen(event: event),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
