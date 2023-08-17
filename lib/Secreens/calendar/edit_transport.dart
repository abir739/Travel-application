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
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late TextEditingController _descriptionController;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.transport.note);
    _noteController = TextEditingController(text: widget.event.transport.note);
    _startDate = widget.event.transport.date!;
    _endDate = widget.event.transport.date!
        .add(Duration(hours: widget.event.transport.durationHours ?? 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 16),
            Text(
                'Start Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(_startDate)}'),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startDate),
                  );

                  if (selectedTime != null) {
                    setState(() {
                      _startDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
              child: const Text('Select Start Date'),
            ),
            const SizedBox(height: 16),
            Text(
                'End Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(_endDate)}'),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endDate),
                  );

                  if (selectedTime != null) {
                    setState(() {
                      _endDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
              child: const Text('Select End Date'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Update the event details based on user input
                widget.event.transport.note = _noteController.text;
                widget.event.transport.date = _startDate;
                widget.event.transport.durationHours =
                    _endDate.difference(_startDate).inHours;

                // You can perform any additional updates here before navigating back
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
