import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../login.dart';
import '../modele/activitsmodel/httpTransfer.dart';
import '../modele/planningmainModel.dart';
import 'package:get/get.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MyCalendarPage extends StatefulWidget {
  final PlanningMainModel? planning;
  final TouristGuide? guid;

  const MyCalendarPage({Key? key, this.planning, this.guid}) : super(key: key);

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late DateTime startDate;
  late DateTime endDate;
  HTTPHandlerTransfer transporthandler = HTTPHandlerTransfer();
  var transferlist;

  @override
  void initState() {
    super.initState();
    startDate = widget.planning?.startDate ?? DateTime.now();
    endDate = widget.planning?.endDate ?? DateTime.now().add(const Duration(days: 7));
  }

  Future<List<Transport>> _loadData() async {
    try {
      // Fetch data using transporthandler and API endpoint
      transferlist = await transporthandler
          .fetchData("/api/transfers/touristGuidId/${widget.guid!.id}");

      // Update the transferlist with fetched data

      return transferlist; // Return the fetched data
    } catch (e) {
      if (transferlist == null || transferlist.isEmpty) {
        Get.to(const MyLogin()); // Navigate to MyLogin page if transferlist is empty
      }
      // Handle any errors that might occur during data fetching
      print("Error loading data: $e");
      return []; // Return an empty list in case of an error
    }
  }

  CalendarDataSource _getCalendarDataSource(List<Transport> tansports) {
    List<Appointment> appointments = [];

    for (Transport transfer in tansports) {
      appointments.add(Appointment(
          isAllDay: transfer.confirmed ?? true,
          id: transfer.id,
          notes: transfer.note,
          startTime: transfer.date ?? DateTime.now(),
          subject: 'from ${transfer.from} to ${transfer.to}',
          endTime:
              transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
          color: const Color.fromARGB(255, 245, 205, 7)));
    }

    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Transport>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            return SfCalendar(
              allowDragAndDrop: true,
              view: CalendarView.day,
              dataSource: _getCalendarDataSource(snapshot.data ?? []),
            );
          }
        },
      ),
    );
  }
}
