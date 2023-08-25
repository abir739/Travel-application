import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../modele/Event/Event.dart';

// class CustomCalendarDataSource extends CalendarDataSource {
//   CustomCalendarDataSource(List<CalendarEvent> events) {
//     appointments = events;
//   }
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].startTime!;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].endTime!;
//   }

//   @override
//   String getSubject(int index) {
//     return appointments![index].title ?? "No Title";
//   }

//   // Add any additional methods that are required to override the abstract methods
//   // of the CalendarDataSource class.
// }
class CustomCalendarDataSource extends CalendarDataSource {
  final Map<CalendarEvent, Color>? eventColors;

  CustomCalendarDataSource(List<CalendarEvent> events, this.eventColors) {
    appointments = events;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime!;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime!;
  }

  @override
  String getId(int index) {
    return appointments![index].id!;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title!;
  }

  // @override
  // String getRecurrenceId(int index) {
  //   return appointments![index].recurrenceId!;
  // }
  Color getColor(int index) {
    CalendarEvent event = appointments![index] as CalendarEvent;
    return event.color ?? super.getColor(index);
  }

  String getSubjecs(int index) {
    return appointments![index].description;
  }

  // Override the appointmentTextStyleBuilder to apply custom colors
  @override
  TextStyle? appointmentTextStyleBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    CalendarEvent event = details.appointments.first;
    return TextStyle(
      color: eventColors![event] ??
          Color.fromARGB(255, 210, 9, 9), // Default to blue if color not found
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
