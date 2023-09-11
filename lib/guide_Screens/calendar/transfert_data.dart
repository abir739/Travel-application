import 'dart:ui';
import 'package:flutter/material.dart'; // Make sure to import the material package

import 'package:zenify_trip/modele/Event/Event.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class TransportEvent extends CalendarEvent {
  final Transport transport;

  TransportEvent(this.transport)
      : super(
          title:
              "🚌 From ${transport.from} to ${transport.to}", // Fixed the title string
          id: transport.id,
          description: "Transfer Guid",
          startTime: transport.date,
          type: transport
              .toString(), // Changed 'type' to a string representation of transport
          endTime: transport.date!
              .add(Duration(hours: transport.durationHours ?? 0)),
          note: "From ${transport.from} to ${transport.to}",
          color: const Color(
              0xFFEB5F52), // Changed Color.fromARGB to Color.fromRGBO
        );
}
