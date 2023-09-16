import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zenify_trip/guide_Screens/calendar/transfert_data.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/svg.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';

class EventView extends StatefulWidget {
  final TransportEvent event;
  final Function(TransportEvent updatedEvent) onSave;
  const EventView({Key? key, required this.event, required this.onSave})
      : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  late TextEditingController _noteController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();

    _noteController = TextEditingController(text: widget.event.transport.note);
    _durationController = TextEditingController(
        text: widget.event.transport.durationHours.toString());
  }

  @override
  void dispose() {
    _noteController.dispose();
    _durationController.dispose();

    super.dispose();
  }

  Widget _buildTouristGroupsList() {
    if (widget.event.transport.touristGroups == null) {
      // Display a message when no tourist groups are available
      return const Text('No tourist groups associated with this event.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.event.transport.touristGroups!.map((group) {
        return Text(
          '- ${group.name}', // Modify this based on your TouristGroup model
          style: const TextStyle(fontSize: 16),
        );
      }).toList(),
    );
  }

  // Define a function to update the event details
  void updateEventDetails(String newNote, int newDuration, int newstartTime) {
    widget.event.transport.note = newNote;
    widget.event.transport.durationHours = newDuration;
  }

  void _saveChanges() async {
    // Update the event details with the changes from the text fields
    widget.event.transport.note = _noteController.text;
    widget.event.transport.durationHours = int.parse(_durationController.text);

    widget.onSave(widget.event);
    String formatter(String url) {
      return baseUrls + url;
    }

    try {
      // Create a JSON payload with the updated event details
      final Map<String, dynamic> updatePayload = {
        'note': _noteController.text,
        'durationHours': int.parse(_durationController.text),

        // Add other fields you want to update
      };

      String? token = await storage.read(key: "access_token");
      String url = formatter("/api/transfers/${widget.event.transport.id}");

      // Perform the PUT request to update the event
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatePayload),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully updated
        // You might want to refetch the data after saving
        //await fetchDataAndOrganizeEvents();
        Navigator.pop(
            context); // Close the EventView screen after saving changes
      } else {
        // Handle API error
        print("API Error: ${response.statusCode}");
        // You can show an error message to the user here
      }

      // Call the function directly from the state
      Navigator.pop(context); // Close the EventView screen after saving changes
    } catch (e) {
      // Handle errors
      print("Error: $e");
    }
  }

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
            Text('Title: ${widget.event.transport.note}'),
            const SizedBox(height: 16),
            Text('Date: ${widget.event.startTime.toString()}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (hours)'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tourist Groups:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Display the list of tourist groups here
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.event.transport.touristGroups?.length ?? 0,
              itemBuilder: (context, index) {
                return Text(
                    widget.event.transport.touristGroups?[index].name ?? '');
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFEB5F52), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _saveChanges,
              child: const Center(
                child: Text(
                  'Save Changes',
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
