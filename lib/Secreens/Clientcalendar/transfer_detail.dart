import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../modele/transportmodel/transportModel.dart'; // For formatting DateTime
// Import your Transport model

class EventDetailScreen extends StatelessWidget {
  final Transport event;

  const EventDetailScreen({required this.event});

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
            Text(
              'Event ID: ${event.id ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
                'Date: ${DateFormat.yMd().add_jm().format(event.date ?? DateTime.now())}'),
            const SizedBox(height: 8.0),
            Text('From: ${event.from ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('To: ${event.to ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('Duration: ${event.durationHours ?? 0} hours'),
            const SizedBox(height: 8.0),
            Text('Note: ${event.note ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text('Confirmed: ${event.confirmed ?? false}'),
            const SizedBox(height: 8.0),
            // You can display more properties of the event as needed
          ],
        ),
      ),
    );
  }
}
