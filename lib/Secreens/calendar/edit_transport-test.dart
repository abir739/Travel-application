import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zenify_trip/Secreens/calendar/transfert_data.dart'; // Import your necessary classes
import 'package:zenify_trip/Secreens/calendar/transfert_data.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:http/http.dart' as http;

import '../../constent.dart';
import '../PlannigSecreen.dart';

class EditEventScreen extends StatefulWidget {
  final TransportEvent event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController noteController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    startTimeController =
        TextEditingController(text: widget.event.startTime.toString());
    endTimeController =
        TextEditingController(text: widget.event.endTime.toString());
    noteController = TextEditingController(text: widget.event.note);
    descriptionController =
        TextEditingController(text: widget.event.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    noteController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateTransfer(
      String transferId, Map<String, dynamic> updateData) async {
    final apiUrl =
        '${baseUrls}/transfers/$transferId'; // Replace with your actual API URL

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // Add any necessary authentication headers here
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      // Transfer updated successfully
      print('Transfer updated successfully');
    } else {
      // Handle errors
      print('Error updating transfer: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: 'Start Date'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: 'End Date'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Update the event details
                widget.event.title = titleController.text;
                widget.event.startTime =
                    DateTime.parse(startTimeController.text);
                widget.event.endTime = DateTime.parse(endTimeController.text);
                widget.event.note = noteController.text;
                widget.event.description = descriptionController.text;

                // Prepare the update data
                final updateData = {
                  'title': widget.event.title,
                  'startTime': widget.event.startTime != null
                      ? widget.event.startTime!.toIso8601String()
                      : null,
                  'endTime': widget.event.endTime != null
                      ? widget.event.endTime!.toIso8601String()
                      : null,
                  'note': widget.event.note,
                  'description': widget.event.description,
                };

                try {
                  // Ensure that widget.event.id is not null before passing it
                  if (widget.event.id != null) {
                    await updateTransfer(widget.event.id!, updateData);
                    // After updating, you can navigate back to the EventView screen
                    Navigator.pop(context);
                  } else {
                    // Handle the case where widget.event.id is null
                    print('Error: Event ID is null');
                  }
                } catch (error) {
                  // Handle errors if the update fails
                  print('Error updating transfer: $error');
                  // You can also show a Snackbar or AlertDialog to inform the user about the error
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
