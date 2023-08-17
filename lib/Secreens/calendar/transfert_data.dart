import 'dart:ui';
import 'package:flutter/material.dart'; // Make sure to import the material package

import 'package:zenify_trip/modele/Event/Event.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

class TransportEvent extends CalendarEvent {
  final Transport transport;

  TransportEvent(this.transport)
      : super(
          title: "T-R ${transport.note}",
          id: transport.id,
          description: "Transfer Guid",
          startTime: transport.date,
          type: transport,
          endTime: transport.date!.add(Duration(hours: transport.durationHours ?? 0)),
          note: "From ${transport.from} to ${transport.to}", // Corrected the note string
          color: const Color.fromARGB(200, 2, 152, 172), // Adjust this according to your Transport class
        );
}
