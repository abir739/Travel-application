import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Tasks> source) {
    appointments = source.map((task) {
      return Appointment(
        id: task.id,
        startTime: formatDateTimeInTimeZone(task.todoDate ??
            DateTime.now()), // Provide a default value when todoDate is null
        endTime:
            DateTime.now(), // Provide a default value when todoDate is null
        isAllDay: false, // Adjust as needed
        subject: task.description ?? '',
        color: const Color(0xFFCBA36E),
      );
    }).toList();
  }
}
