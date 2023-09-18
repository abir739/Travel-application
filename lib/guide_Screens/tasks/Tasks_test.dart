import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';

class TaskListPage extends StatefulWidget {
  final String? guideId;

  TaskListPage({super.key, required this.guideId});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Tasks> _tasksList = [];
  List<DateTime> days = [];
  late DateTime selectedDay;
  final DateTime _startDate = DateTime.now().subtract(const Duration(days: 3));
  final DateTime _endDate = DateTime.now().add(const Duration(days: 20));
  final List<DateTime> _days = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    selectedDay = DateTime.now();
    days =
        List.generate(10, (index) => DateTime.now().add(Duration(days: index)));
    int daysDifference = _endDate.difference(_startDate).inDays;
    for (int i = 0; i <= daysDifference; i++) {
      _days.add(_startDate.add(Duration(days: i)));
    }
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
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  void updateTask(int index) {
    Tasks task = _tasksList[index];

    // Navigate to the task editing screen and pass the task data
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TaskEditScreen(task: task)),
    // ).then((updatedTask) {
    //   if (updatedTask != null) {
    //     setState(() {
    //       _tasksList[index] = updatedTask;
    //     });
    //   }
    // });
  }

  void addTask() {
    // Navigate to the task creation screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TaskCreateScreen()),
    // ).then((newTask) {
    //   if (newTask != null) {
    //     setState(() {
    //      _tasksList.add(newTask);
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/Logo.svg',
          fit: BoxFit.cover,
          height: 36.0,
        ),
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
      ),
      body: Column(children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 5.0),
                  const Text(
                    'Daily tasks',
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3557),
                    ),
                  ),
                  const SizedBox(width: 84.5),
                  Container(
                    height: 40.0,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB5F52),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFEB5F52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        addTask();
                      },
                      child: const Center(
                        child: Text(
                          'Add Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35.0),
              SizedBox(
                height: 40.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (BuildContext context, int index) {
                    final day = _days[index];
                    String dayOfWeek = "";
                    switch (day.weekday) {
                      case 1:
                        dayOfWeek = "MON";
                        break;
                      case 2:
                        dayOfWeek = "TUE";
                        break;
                      case 3:
                        dayOfWeek = "WED";
                        break;
                      case 4:
                        dayOfWeek = "THU";
                        break;
                      case 5:
                        dayOfWeek = "FRI";
                        break;
                      case 6:
                        dayOfWeek = "SAT";
                        break;
                      case 7:
                        dayOfWeek = "SUN";
                        break;
                    }
                    bool isSelected = _currentIndex == _days.indexOf(day);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = _days.indexOf(day);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: isSelected
                              ? const Color.fromARGB(255, 248, 177, 170)
                              : Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dayOfWeek,
                              style: const TextStyle(
                                color: Color(0xFFEB5F52),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: (day == _currentIndex)
                                    ? const Color(0xFFEB5F52)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 0.05),
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              final startTime = TimeOfDay(hour: 9 + index, minute: 0);
              final endTime = TimeOfDay(hour: 10 + index, minute: 0);
              if (index < _tasksList.length) {
                final task = _tasksList[index];

                return InkWell(
                  onTap: () {
                    // Navigate to activity details page
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Container(
                                height: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xFFEB5F52),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(task.todoDate ?? ''),
                                    const SizedBox(height: 4.0),
                                    Text(task.description ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 4.0,
                        child: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'update',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Update Task'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete_forever),
                                title: Text('Delete Task'),
                              ),
                            ),
                          ],
                          onSelected: (String value) {
                            if (value == 'update') {
                              updateTask(index);
                            } else if (value == 'delete') {
                              setState(() {
                                _tasksList.removeAt(index);
                              });
                            } else if (value == 'new') {
                              addTask();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ]),
    );
  }
}
