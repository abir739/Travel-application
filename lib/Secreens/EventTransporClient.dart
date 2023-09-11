import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:analog_clock/analog_clock.dart';


import '../modele/transportmodel/transportModel.dart';

class EventViewTraveller extends StatefulWidget {
  final Appointment appointment;
 

  const EventViewTraveller({required this.appointment, Key? key})
      : super(key: key);



  @override
  _EventViewTravellerState createState() => _EventViewTravellerState();
}

class _EventViewTravellerState extends State<EventViewTraveller> {
  Transport? transport;

  @override
  void initState() {
    super.initState();
if (widget.appointment.recurrenceId is Transport) {
      transport = widget.appointment.recurrenceId as Transport?;
    } else {
      transport = null; // or handle the case where it's not a Transport
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  
 SizedBox(
              height: 200, // Set an appropriate height
              width: 200, // Set an appropriate width
              child: AnalogClock(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                width: 150.0,
                isLive: true,
                hourHandColor: Colors.blue,
                minuteHandColor: Colors.blue,
                secondHandColor: Colors.red,
                showSecondHand: true,
                showNumbers: true,
                textScaleFactor: 2.0,
                datetime: widget.appointment.startTime ?? DateTime.now(),
              ),
          ),
            Text('Event ID: ${widget.appointment.id ?? 'N/A'}'),
            Text('Start Time: ${widget.appointment.startTime ?? 'N/A'}'),
            Text('End Time: ${widget.appointment.endTime ?? 'N/A'}'),
            // Text(
            //     'End recurrenceId: ${widget.appointment?.recurrenceId ?? 'N/A'}'),
            Text('Transport from: ${transport?.from ?? 'N/A'}'),
            // Add more details about the appointment and transport as needed
          ],
        ),
      ),
    );
  }
}
