import 'dart:ui';

import 'package:cr_calendar/cr_calendar.dart';

import 'dart:ui';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart'; // Make

class CalendarEvent {
  final String? title;
  final String? id;
  final String? description;
  final String? location;
  final String? from;
  final String? to;
  final String? note;

  final DateTime? startTime;
  final DateTime? endTime;
  final Color? color;
  final Object? type;
  final Object? recurrenceId;
  Color? cardcolor;
  final TextStyle? displayNameTextStyle;
  CalendarEvent(
      {this.title,
      this.description,
      this.location,
      this.from,
      this.to,
      this.startTime,
      this.endTime,
      this.color,
      this.id,
      this.recurrenceId,
      this.note,
      this.cardcolor,
      this.type,
      this.displayNameTextStyle});
}
