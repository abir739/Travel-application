import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/modele/tasks/taskModel.dart';

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Tasks> source) {
    appointments = source.map((task) {
      DateTime todoDate = task.todoDate ?? DateTime.now();
      DateTime endTime = todoDate.add(Duration(hours: 20));

      return Appointment(
        id: task.id,
        startTime: formatDateTimeInTimeZone(todoDate),
        endTime: formatDateTimeInTimeZone(endTime),
        isAllDay: false,
        subject: '${task.description ?? ''}',
        color: const Color(0xFFCBA36E),
      );
    }).toList();
  }
}
