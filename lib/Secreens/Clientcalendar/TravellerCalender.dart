
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';
import 'package:get/get.dart';
import '../../modele/Event/Event.dart';
import '../../modele/activitsmodel/httpTransfer.dart';
import '../EventTransporClient.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class TravellerCalendarPage extends StatefulWidget {
  final String? group;

  const TravellerCalendarPage({Key? key, this.group}) : super(key: key);

  @override
  _TravellerCalendarPageState createState() => _TravellerCalendarPageState();
}

class _TravellerCalendarPageState extends State<TravellerCalendarPage> {
  late DateTime startDate;
  String dateString = DateTime.now().toString();
  late DateTime endDate;
  final CalendarController _controller = CalendarController();
  HTTPHandlerTransfer transporthandler = HTTPHandlerTransfer();
  // var transferlist;
  List<Transport> transferList = [];
  @override
  void initState() {
    super.initState();
    _loadData();
    fetchData();
  }

  List<CalendarEvent> convertToCalendarEvents(List<Transport> transfers) {
    List<CalendarEvent> events = [];

    for (var transfer in transfers) {
      events.add(CalendarEvent(
        title: "T-R ${transfer.note}",
        id: transfer.id,
        description: "Transfer Guid",
        startTime: transfer.date,
        type: transfer,
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
        color: Color.fromARGB(200, 2, 152, 172),
      ));
    }

    return events;
  }

  Future<void> fetchData() async {
    try {
      transferList = await transporthandler
          .fetchData("/api/transfers/touristgroups/${widget.group}");
      setState(() {
        List<CalendarEvent> events = convertToCalendarEvents(transferList);
      });
    } catch (e) {
      // Handle error
      print("Handle error $e");
    }
  }

  Future<List<Transport>> _loadData() async {
    try {
      // Fetch data using transporthandler and API endpoint
      transferList = await transporthandler
          .fetchData("/api/transfers/touristgroups/${widget.group}");

      // Update the transferlist with fetched data

      return transferList; // Return the fetched data
    } catch (e) {
      if (transferList == null || transferList.isEmpty) {
       
      }
      // Handle any errors that might occur during data fetching
      print("Error loading data: $e ${widget.group}");
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
          recurrenceId: transfer,
          startTime: transfer.date ?? DateTime.now(),
          subject: 'from ${transfer.from} to ${transfer.to}',
          endTime:
              transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
          color: Color.fromARGB(255, 245, 205, 7)));
    }

    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar Page'),
        ),
        body: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView(
            children: [
              Container(
                height: Get.height * 0.88,
                child: SfCalendar(
                  todayHighlightColor: Color.fromARGB(255, 242, 186, 3),
                  todayTextStyle: const TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 238, 234, 238)),
                  monthCellBuilder:
                      (BuildContext context, MonthCellDetails details) {
                    // Customize the appearance of each month cell based on the details
                    return Container(
                      decoration: BoxDecoration(
                        color: details.date.month == DateTime.now().month
                            ? const Color.fromARGB(255, 245, 242, 242)
                            : const Color.fromARGB(255, 242, 186, 3),
                        border: Border.all(
                            color: Color.fromARGB(255, 20, 1, 1), width: 0.5),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            details.date.day.toString(),
                            style: TextStyle(
                              fontSize: 23,
                              color: details.visibleDates.contains(details.date)
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            details.appointments.length.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: details.visibleDates.contains(details.date)
                                  ? Color.fromARGB(255, 236, 2, 2)
                                  : Color.fromARGB(255, 248, 2, 2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  headerHeight: 30,
                  controller: _controller,
                  view: CalendarView.schedule,
                 
                  scheduleViewMonthHeaderBuilder: (
                    BuildContext context,
                    ScheduleViewMonthHeaderDetails headerDetails,
                  ) {
                    // You can return a custom widget here to be displayed as the header.

                    return Container(
                      color: Color.fromARGB(255, 6, 164, 255),
                      child: Column(
                        children: [
                          Text(
                            style: const TextStyle(fontSize: 40),
                            '${headerDetails.date.day} ,${headerDetails.date.month} ,${headerDetails.date.year}',
                          ),
                        ],
                      ),
                    );
                  },
                  viewNavigationMode: ViewNavigationMode.snap,
                  onTap: (CalendarTapDetails details) {
                    calendarTapped(
                        context, details); // Call your calendarTapped function
                  },
                  showDatePickerButton: true,
                  resourceViewSettings: const ResourceViewSettings(
                      visibleResourceCount: 4,
                      showAvatar: false,
                      displayNameTextStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Color.fromARGB(255, 250, 248, 246),
                          fontWeight: FontWeight.w400)),

                  allowedViews: const <CalendarView>[
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.workWeek,
                    CalendarView.month,
                    CalendarView.schedule
                  ],
                  initialDisplayDate: DateTime.parse(dateString),
                  dataSource: _getCalendarDataSource(transferList),
                  monthViewSettings: MonthViewSettings(
                      navigationDirection: MonthNavigationDirection.horizontal,
                      showAgenda: true,
                
                      agendaItemHeight: Get.height * 0.1,
                      numberOfWeeksInView: 5,
                     
                      monthCellStyle: const MonthCellStyle(
                        todayBackgroundColor: Colors.red,
                        textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 243, 239, 239)),
                      ),
                      agendaStyle: const AgendaStyle(
                        backgroundColor: Color.fromARGB(218, 1, 9, 22),
                        appointmentTextStyle: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(239, 236, 235, 234)),
                        dateTextStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 240, 4, 200)),
                        dayTextStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 240, 4, 200)),
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Appointment appointment =
          calendarTapDetails.appointments![0] as Appointment;
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => EventViewTraveller(appointment: appointment)),
      );
    }
  }
}
