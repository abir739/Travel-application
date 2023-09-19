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
                  agendaViewHeight: 200,
                ),
                headerDateFormat: 'MMM,yyy',
                dataSource: _dataSource,
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                  final appointment = details.appointments.first;

                  // Customize how your tasks are displayed here
                  return Container(
                    color: appointment.isAllDay
                        ? const Color.fromARGB(255, 166, 33, 243)
                        : Colors.green,
                    child: Center(
                      child: Text(appointment.subject ?? ''),
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
                    _showAppointmentsDialog(
                        context, details.appointments!.cast<Appointment>());
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
