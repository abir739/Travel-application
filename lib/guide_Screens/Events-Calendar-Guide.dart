import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/login/login_Page.dart';
import 'dart:convert';
import 'package:zenify_trip/guide_Screens/calendar/Event_Details.dart';
import 'package:zenify_trip/modele/activitsmodel/activitesmodel.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class EventCalendarDataSource extends CalendarDataSource {
  EventCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class EventCalendar extends StatefulWidget {
  final String? guideId;

  EventCalendar({required this.guideId});

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  List<Activity> activities = [];
  List<Tasks> tasks = [];
  List<Transport> transfers = [];

  @override
  void initState() {
    super.initState();
    fetchActivities();
    fetchTasks();
    fetchTransfers();
  }

  Future<void> fetchActivities() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/activities?filters[touristGuideId]=${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      activities =
          results.map((groupData) => Activity.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  Future<void> fetchTasks() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tasks?filters[touristGuideId]=${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      tasks = results.map((groupData) => Tasks.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  Future<void> fetchTransfers() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/transfers/touristGuidId/${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      transfers =
          results.map((groupData) => Transport.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  void _onTransferAppointmentTapped(Transport transfer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventView(
          transport: transfer,
          onSave: handleEventSave, // Pass the method
        ),
      ),
    );
  }

  void handleEventSave(Transport updatedEvent) {
    setState(() {
      // Update the event list with the changes
      int index =
          transfers.indexWhere((element) => element.id == updatedEvent.id);
      if (index != -1) {
        transfers[index] = updatedEvent;
      }
    });
  }

  void _onTaskAppointmentTapped(Tasks task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add New'),
                  onTap: () {
                    // Handle "Add New" option
                    Navigator.pop(context);
                    // Add your logic for handling "Add New"
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    // Handle "Delete" option
                    Navigator.pop(context);
                    // Add your logic for handling "Delete"
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    // Handle "Edit" option
                    Navigator.pop(context);
                    // Add your logic for handling "Edit"
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Calendar'),
      ),
      body: SfCalendar(
        allowedViews: const <CalendarView>[
          CalendarView.month,
          CalendarView.schedule,
        ],
        view: CalendarView.schedule,
        dataSource: EventCalendarDataSource(_getCalendarAppointments()),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            Appointment tappedAppointment = details.appointments![0];
            String appointmentSubject = tappedAppointment.subject;

            if (appointmentSubject.startsWith('Task')) {
              // Find the associated task
              Tasks task = tasks.firstWhere(
                (t) => 'Task: ${t.description}' == appointmentSubject,
                orElse: () => Tasks(description: ''),
              );

              // Show Options for the task appointment
              _onTaskAppointmentTapped(task);
            } else if (appointmentSubject.startsWith('Transfer')) {
              Transport transfer = transfers.firstWhere(
                (t) => 'Transfer: ${t.from} to ${t.to}' == appointmentSubject,
                orElse: () => Transport(),
              );

              _onTransferAppointmentTapped(transfer);
            }
          }
        },
      ),
    );
  }

  List<Appointment> _getCalendarAppointments() {
    List<Appointment> appointments = [];

    // Add activities to the calendar
    for (var activity in activities) {
      appointments.add(Appointment(
        startTime: activity.departureDate!,
        endTime: activity.returnDate!,
        subject: 'Activity: ${activity.name}',
        color: const Color.fromARGB(255, 240, 70, 223),
      ));
    }

    // Add tasks to the calendar
    for (var task in tasks) {
      appointments.add(Appointment(
        startTime: task.todoDate!,
        endTime: task.todoDate!,
        subject: 'Task: ${task.description}',
        color: Colors.green,
      ));
    }

    // Add transfers to the calendar
    for (var transfer in transfers) {
      appointments.add(Appointment(
        startTime: transfer.date!,
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
        subject: 'Transfer: ${transfer.from} to ${transfer.to}',
        color: Colors.red,
      ));
    }

    return appointments;
  }
}
