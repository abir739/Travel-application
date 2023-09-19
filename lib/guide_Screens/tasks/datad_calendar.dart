import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Tasks> source) {
    appointments = source.map((task) {
      return Appointment(
        startTime: DateTime.parse(task.todoDate!),
        endTime: DateTime.parse(task.todoDate!),
        isAllDay: false, // Adjust as needed
        subject: task.description ?? '',
        color: Colors.green,
      );
    }).toList();
  }
}
