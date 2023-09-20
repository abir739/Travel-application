import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/guide_Screens/tasks/datad_calendar.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskListPage extends StatefulWidget {
  final String? guideId;

  TaskListPage({super.key, required this.guideId});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Tasks> _tasksList = [];
  TaskDataSource _dataSource = TaskDataSource([]);
  final CalendarController _controller = CalendarController();
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
      _tasksList =
          results.map((groupData) => Tasks.fromJson(groupData)).toList();
      _dataSource = TaskDataSource(_tasksList); // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  Future<void> _showAppointmentsDialog(
    BuildContext context,
    List<Appointment> appointments,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Tasks for ${selectedDate?.toLocal()} : ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: appointments
                .asMap()
                .entries
                .map(
                  (entry) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${entry.key + 1}. ${entry.value.subject ?? 'No Subject'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // Add logic to show more details for this appointment
                            _showAppointmentDetails(context, entry.value);
                          },
                        ),
                      ),
                      if (entry.key < appointments.length - 1) Divider(),
                    ],
                  ),
                )
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to show more details about a specific appointment
  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Appointment Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject: ${appointment.subject ?? 'No Subject'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),

              // Add more appointment details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Task Description'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    String newTaskDescription = descriptionController.text;
                    String? newTaskTodoDate;

                    if (selectedDate != null) {
                      newTaskTodoDate = selectedDate?.toLocal().toString();
                    }

                    // Send a POST request to add the task
                    String? token = await storage.read(key: "access_token");
                    String url = "$baseUrls/api/tasks";
                    final response = await http.post(
                      Uri.parse(url),
                      headers: {
                        "Authorization": "Bearer $token",
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode({
                        "touristGuideId": widget.guideId,
                        "description": newTaskDescription,
                        "todoDate": newTaskTodoDate,
                        // Add other task properties as needed
                      }),
                    );

                    if (response.statusCode == 201) {
                      // Task added successfully, update the calendar
                      fetchData();
                      Navigator.of(context).pop(true); // Return true on success
                    } else {
                      // Handle error
                      print("Error adding task: ${response.statusCode}");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {}
  }

  void _deleteTask(Appointment appointment) async {
    // Find and remove the task from the data source
    _dataSource.appointments!.removeWhere(
        (existingAppointment) => existingAppointment == appointment);

    // Update the UI
    setState(() {});

    // Send an HTTP DELETE request to delete the task on the server
    String? token = await storage.read(key: "access_token");
    String url =
        "$baseUrls/api/tasks/${appointment.id}"; // Replace with your API endpoint

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      // Task deleted successfully from the server
    } else {
      // Handle error
      print("Error deleting task: ${response.statusCode}");
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
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF3A3557),
                    Color(0xFFCBA36E),
                    Color(0xFFEB5F52),
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                '  Tasks List',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors
                      .white, // You can adjust the font size and color here
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Add an icon button to the app bar for adding tasks
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTaskDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView(
          children: [
            SizedBox(
              height: Get.height * 0.88,
              child: SfCalendar(
                todayHighlightColor: const Color(0xFFEB5F52),
                todayTextStyle: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 238, 234, 238)),
                monthCellBuilder:
                    (BuildContext context, MonthCellDetails details) {
                  // Customize the appearance of each month cell based on the details
                  return Container(
                    decoration: BoxDecoration(
                      color: details.date.month == DateTime.now().month
                          ? const Color.fromARGB(255, 245, 242, 242)
                          : const Color.fromARGB(255, 179, 228, 236),
                      border: Border.all(
                          color: const Color.fromARGB(255, 207, 207, 219),
                          width: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          details.date.day.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: details.visibleDates.contains(details.date)
                                ? Colors.black87
                                : const Color.fromARGB(255, 158, 158, 158),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          details.appointments.length.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: details.visibleDates.contains(details.date)
                                ? const Color.fromARGB(255, 87, 6, 134)
                                : const Color.fromARGB(255, 87, 6, 134),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                headerHeight: 40,
                controller: _controller,
                allowedViews: const <CalendarView>[
                  CalendarView.month,
                  CalendarView.schedule,
                ],
                view: CalendarView.month,
                showDatePickerButton: true,
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  agendaViewHeight: 300,
                  numberOfWeeksInView: 4,
                  agendaItemHeight: 75,
                ),
                // headerDateFormat: 'MMM,yyy',
                dataSource: _dataSource,
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                  final appointment = details.appointments.first;

                  // Wrap the appointment in a Slidable widget
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        // Add your edit action here
                        SlidableAction(
                          label: 'Edit',
                          backgroundColor: Colors.blue,
                          icon: Icons.edit,
                          onPressed: (context) {
                            // Handle edit action
                            // You can open an edit dialog or navigate to an edit screen here
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.70,
                      children: [
                        // Add your delete action here
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            // Show a confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete this task?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () async {
                                        _deleteTask(appointment);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        // Add your add action here
                        SlidableAction(
                          label: 'Add',
                          backgroundColor: Colors.green,
                          icon: Icons.add,
                          onPressed: (context) {
                            // Open the add task dialog
                            _showAddTaskDialog(context);
                          },
                        ),
                      ],
                    ),
                    child: Container(
                      color: appointment.isAllDay
                          ? const Color.fromARGB(255, 166, 33, 243)
                          : const Color(0xFFCBA36E),
                      child: Center(
                        child: Text(appointment.subject ?? ''),
                      ),
                    ),
                  );
                },
                onTap: (CalendarTapDetails details) {
                  // Handle day cell tap
                  if (details.targetElement == CalendarElement.calendarCell &&
                      details.appointments != null &&
                      details.appointments!.isNotEmpty) {
                    setState(() {
                      selectedDate = details.date;
                    });
                    // _showAppointmentsDialog(
                    //     context, details.appointments!.cast<Appointment>());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
