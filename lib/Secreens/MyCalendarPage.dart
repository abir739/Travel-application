import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../modele/activitsmodel/activitesmodel.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/httpTransfer.dart';
import '../modele/planningmainModel.dart';


class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MyCalendarPage extends StatefulWidget {
  final PlanningMainModel? planning;
  final TouristGuide? guid;

  const MyCalendarPage({Key? key, this.planning,this.guid}) : super(key: key);

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
    endDate = widget.planning?.endDate ?? DateTime.now().add(Duration(days: 7));
  }

  Future<List<Transport>>? _loadData() async {
    setState(() {
      transferlist = transporthandler.fetchData(
          "/api/transfers/touristGuidId/${widget.guid!.id}");
    });
    return transferlist;
  }

  CalendarDataSource _getCalendarDataSource(List<Transport> tansports) {
    List<Appointment> appointments = [];

    for (Transport transfer in tansports) {
      appointments.add(Appointment(
  isAllDay :transfer.confirmed ?? true,
        id: transfer.id,
       notes:transfer.note,
        startTime: transfer.date ?? DateTime.now(),
  subject :'from ${transfer.from } to ${transfer.to}',
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
color: Color.fromARGB(255, 245, 205, 7)
      ));
    }

    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
       
      //  title: Text('Calendar Page'),
      // ),
      body: FutureBuilder<List<Transport>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            return SfCalendar(allowDragAndDrop :true,
              view: CalendarView.day,
              dataSource: _getCalendarDataSource(snapshot.data ?? []),
            );
          }
        },
      ),
    );
  }
}
