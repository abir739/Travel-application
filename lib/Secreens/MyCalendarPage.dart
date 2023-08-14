import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../modele/activitsmodel/activitesmodel.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/planningmainModel.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MyCalendarPage extends StatefulWidget {
  final PlanningMainModel? planning;

  const MyCalendarPage({Key? key, this.planning}) : super(key: key);

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late DateTime startDate;
  late DateTime endDate;
  HTTPHandlerActivites activiteshanhler = HTTPHandlerActivites();
  var activiteslist1;

  @override
  void initState() {
    super.initState();
    startDate = widget.planning?.startDate ?? DateTime.now();
    endDate = widget.planning?.endDate ?? DateTime.now().add(Duration(days: 7));
  }

  Future<List<Activity>>? _loadData() async {
    setState(() {
      activiteslist1 = activiteshanhler.fetchData(
          "/api/activities/planningIdDs/${widget.planning!.id}");
    });
    return activiteslist1;
  }

  CalendarDataSource _getCalendarDataSource(List<Activity> activities) {
    List<Appointment> appointments = [];

    for (Activity activity in activities) {
      appointments.add(Appointment(
        startTime: activity.departureDate ?? DateTime.now(),
        endTime: activity.returnDate ?? DateTime.now(),
        subject: activity.name ?? "",
      ));
    }

    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available.');
          } else {
            return SfCalendar(
              view: CalendarView.schedule,
              dataSource: _getCalendarDataSource(snapshot.data ?? []),
            );
          }
        },
      ),
    );
  }
}
