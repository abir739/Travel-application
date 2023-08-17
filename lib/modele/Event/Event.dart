import 'dart:ui';

import 'package:cr_calendar/cr_calendar.dart';

import 'dart:ui';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart'; // Make

class CalendarEvent {
  late final String? title;
  final String? id;
  late final String? description;
  late final String? note;

  late final DateTime? startTime;
  late final DateTime? endTime;
  final Color? color;
  final Object? type;
  Color? cardcolor;
  final TextStyle? displayNameTextStyle;
  CalendarEvent(
      {this.title,
      this.description,
      this.startTime,
      this.endTime,
      this.color,
      this.id,
      this.note,
      this.cardcolor,
      this.type,
      this.displayNameTextStyle});
}
