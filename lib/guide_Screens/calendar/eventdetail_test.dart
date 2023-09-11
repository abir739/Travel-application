import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/guide_Screens/calendar/transfert_data.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/touristGroup.dart'; // Updated import

class EventView extends StatefulWidget {
  final TransportEvent event;
  final Function(TransportEvent updatedEvent) onSave;

  const EventView({super.key, required this.event, required this.onSave});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  List<TouristGroup> _touristGroups = [];

  late TextEditingController _noteController;
  late TextEditingController _durationController;
  late TextEditingController _messageController; // Updated controller name
  late TextEditingController _titleController; // Updated controller name
  late TextEditingController _typeController; // Updated controller name
  bool sendNotification = false;
  bool showNotificationFields = false;

  @override
  void initState() {
    super.initState();
    fetchTouristGroups();

    _noteController = TextEditingController(text: widget.event.transport.note);
    _durationController = TextEditingController(
        text: widget.event.transport.durationHours.toString());

    _messageController = TextEditingController(); // Initialize controllers
    _titleController = TextEditingController(); // Initialize controllers
    _typeController = TextEditingController(); // Initialize controllers
  }

  @override
  void dispose() {
    _noteController.dispose();
    _durationController.dispose();
    _messageController.dispose(); // Dispose of controllers
    _titleController.dispose(); // Dispose of controllers
    _typeController.dispose(); // Dispose of controllers

    super.dispose();
  }

  Future<void> fetchTouristGroups() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tourist-groups/transfrid/${widget.event.transport.id}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      _touristGroups =
          results.map((groupData) => TouristGroup.fromJson(groupData)).toList();
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  // Define a function to update the event details
  void updateEventDetails(String newNote, int newDuration) {
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
      };

      final additionalData = {
        "message": _messageController.text,
        "title": _titleController.text,
        "type": _typeController.text,
        "Screen": _typeController.text,
        "sendNotification": sendNotification
      };
      final newData = {
        "Notification": additionalData,
      };

      // Merge the additional data with the existing data
      updatePayload.addAll(newData);

      String? token = await storage.read(key: "access_token");
      String url = formatter("/api/transfers/${widget.event.transport.id}");

      // Perform the PATCH request to update the event
      final response = await http.patch(
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
        // await fetchDataAndOrganizeEvents();
        Navigator.pop(context);
        print(updatePayload);
        print(response.body);
      } else {
        // Handle API error
        print("API Error: ${response.statusCode}");
        // You can show an error message to the user here
      }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              const Text(
                'Transport Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 26),
              Text('Description: ${widget.event.transport.from}'),
              const SizedBox(height: 14),
              Text('Date: ${widget.event.startTime.toString()}'),
              const SizedBox(height: 14),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Duration (hours)'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tourist Groups:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 13),
              MultiSelectDialogField<TouristGroup>(
                items: _touristGroups
                    .map((group) => MultiSelectItem(group, group.name!))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (selectedItems) {
                  // Handle selected items here
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (item) {
                    // Handle chip tap here
                  },
                ),
              ),
              const SizedBox(height: 18),
              Visibility(
                visible: showNotificationFields,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          labelText: 'Notification Message'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          labelText: 'Notification Title'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _typeController,
                      decoration:
                          const InputDecoration(labelText: 'Notification Type'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                          labelText: 'Notification Screen'),
                    ),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.notification_add,
                      color: Colors.amber,
                    ),
                    const Text(
                      'Send notification',
                      style: TextStyle(
                        color: Colors.black12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoSwitch(
                      value: sendNotification,
                      onChanged: (val) {
                        setState(() {
                          sendNotification = val;
                          showNotificationFields =
                              val; // Update visibility state
                          print(sendNotification.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFEB5F52),
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
      ),
    );
  }
}
