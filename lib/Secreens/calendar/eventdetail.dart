import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenify_trip/Secreens/calendar/transfert_data.dart';

class EventView extends StatelessWidget {
  final TransportEvent event; // Assuming you have a TransportEvent class

  EventView({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
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
          ],
        ),
      ),
    );
  }
}
