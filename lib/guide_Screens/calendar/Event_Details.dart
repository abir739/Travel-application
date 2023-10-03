import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:zenify_trip/constent.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenify_trip/login/login_Page.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class EventView extends StatefulWidget {
  final Transport transport;
  final Function(Transport updatedTransport) onSave;

  const EventView({
    Key? key,
    required this.transport,
    required this.onSave,
  }) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  List<TouristGroup> _touristGroups = [];
  TouristGuide? guid;
  late TextEditingController _noteController;
  late TextEditingController _durationController;
  late TextEditingController _messageController;
  late TextEditingController _titleController;
  late TextEditingController _typeController;
  bool sendNotification = false;
  bool showNotificationFields = false;

  @override
  void initState() {
    super.initState();
    fetchTouristGroups();

    _noteController = TextEditingController(text: widget.transport.note);
    _durationController =
        TextEditingController(text: widget.transport.durationHours.toString());

    _messageController = TextEditingController(); // Initialize controllers
    _titleController = TextEditingController(); // Initialize controllers
    _typeController = TextEditingController(); // Initialize controllers
  }

  @override
  void dispose() {
    _noteController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    // Update the properties of the existing transport object
    widget.transport.note = _noteController.text;
    widget.transport.durationHours = int.parse(_durationController.text);

    // Call the onSave callback with the updated transport object
    widget.onSave(widget.transport);

    String formatter(String url) {
      return baseUrls + url;
    }

    try {
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

      updatePayload.addAll(newData);

      String? token = await storage.read(key: "access_token");
      String url = formatter("/api/transfers/${widget.transport.id}");

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
        print(updatePayload);
        print(response.body);
        Navigator.pop(context, true); // Pass 'true' to indicate refresh
      } else {
        print("API Error: ${response.statusCode}");
      }
      // Navigator.pop(context, true);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchTouristGroups() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tourist-groups/transfrid/${widget.transport.id}");

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
              Text(
                'Description: 🚌 From ${widget.transport.from ?? 'N/A'} to ${widget.transport.to ?? 'N/A'}',
              ), // Update with your field
              const SizedBox(height: 14),
              Text(
                'Date: ${widget.transport.date != null ? formatDateTimeInTimeZone(widget.transport.date!).toString() : 'N/A'}', // Update with your field
              ),
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
                onPressed: () async {
                  _saveChanges();
                },
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
