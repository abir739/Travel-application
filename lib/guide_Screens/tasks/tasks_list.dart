import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/login.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';
import 'package:http/http.dart' as http;

class TaskListPage extends StatefulWidget {
  final String? guideId;

  TaskListPage({super.key, required this.guideId});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Tasks> _tasksList = [];

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
