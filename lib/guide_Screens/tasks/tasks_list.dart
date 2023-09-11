import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';
import 'package:http/http.dart' as http;

class TaskListPage extends StatefulWidget {
  final TouristGuide? guid;

  TaskListPage({this.guid});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Tasks> _tasksList = [];
  TouristGuide? get selectedTouristGuide => TouristGuide();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tasks?filters[touristGuideId]=${widget.guid?.id}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      setState(() {
        _tasksList =
            results.map((groupData) => Tasks.fromJson(groupData)).toList();
      });
    } else {
      print("Error fetching tasks list: ${response.statusCode}");
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: _tasksList.length,
        itemBuilder: (context, index) {
          final task = _tasksList[index];
          return ListTile(
            title: Text(task.description ?? ''),
            subtitle: Text(task.todoDate ?? ''),
          );
        },
      ),
    );
  }
}
