import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:zenify_trip/Secreens/calendar/transfert_data.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class EditEventScreen extends StatefulWidget {
  final TransportEvent event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TextEditingController _noteController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.event.note ?? '';
    _descriptionController.text = widget.event.description ?? '';
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
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the existing event with user input
                widget.event.note = _noteController.text;
                widget.event.description = _descriptionController.text;

                // Return the updated event to the previous screen
                Navigator.pop(context, widget.event);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
