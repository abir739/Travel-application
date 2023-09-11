import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/Secreens/CustomCalendarDataSource.dart';
import '../../constent.dart';
import '../../modele/Event/Event.dart';
import '../../modele/transportmodel/transportModel.dart';
import '../../modele/traveller/TravellerModel.dart';
import 'package:flutter_svg/svg.dart';

class CalendarPage extends StatefulWidget {
  final Traveller selectedTraveller;

  const CalendarPage({required this.selectedTraveller, Key? key})
      : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Transport> transfers =
      []; // Create a Transfer class to hold transfer data
  final CalendarController _controller = CalendarController();
  Map<DateTime, List<CalendarEvent>> eventsByDate = {};
  Map<CalendarEvent, Color> eventColors = {};
  String dateString = DateTime.now().toString();
  @override
  void initState() {
    super.initState();

    fetchTransfers();
  }

  CalendarDataSource _getCalendarDataSource() {
    List<CalendarEvent> events = [];
    eventsByDate.forEach((date, eventList) {
      events.addAll(eventList);
    });

    // Create an instance of CalendarDataSource with the events list
    return CustomCalendarDataSource(events, eventColors);
  }

  Future<void> fetchTransfers() async {
    print("${widget.selectedTraveller.touristGroupId}");
    final url = Uri.parse(
      '$baseUrls/api/transfers-mobile/touristgroups/${widget.selectedTraveller.touristGroupId}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final List<dynamic> transferData = responseData["data"];

        setState(() {
          transfers =
              transferData.map((data) => Transport.fromJson(data)).toList();
          print("${transfers[0]}");
        });
      } else {
        // Handle error case
      }
    } catch (error) {
      // Handle error case
    }
  }

  List<CalendarEvent> convertToCalendarEvents(
    List<Transport> transfers,
  ) {
    List<CalendarEvent> events = [];
    for (var transfer in transfers) {
      events.add(CalendarEvent(
        title: "T-R ${transfer.note}",
        id: transfer.id,
        description: "Transfer Group",
        startTime: transfer.date,
        type: transfer,
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
        color: const Color.fromARGB(200, 2, 152, 172),
      ));
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;
    return Container(
      color: const Color.fromARGB(236, 238, 239, 242),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 3, 46, 164),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 207, 207, 219),
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/Frame.svg',
                fit: BoxFit.cover,
                height: 36.0,
              ),
              const SizedBox(width: 30),
              const Text(
                'Your Calendar',
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 5, 150),
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: fetchTransfers,
          child: ListView(
            children: [
              SizedBox(
                height: Get.height * 0.88,
                child: SfCalendar(
                  todayHighlightColor: const Color.fromARGB(255, 242, 186, 3),
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
                            : const Color.fromARGB(255, 179, 228, 236),
                        border: Border.all(
                            color: const Color.fromARGB(255, 207, 207, 219),
                            width: 0.5),
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
                                  : const Color.fromARGB(255, 158, 158, 158),
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
                                  ? const Color.fromARGB(255, 87, 6, 134)
                                  : const Color.fromARGB(255, 87, 6, 134),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  headerHeight: 38,
                  controller: _controller,
                  view: CalendarView.schedule,
                  scheduleViewMonthHeaderBuilder: (BuildContext context,
                      ScheduleViewMonthHeaderDetails details) {
                    // You can return a custom widget here to be displayed as the header.
                    return Container(
                      color: const Color.fromARGB(
                          255, 215, 8, 46), // Set your desired background color
                      child: const Center(
                        child: Text(
                          'Custom Header', // Set your desired header text
                          style: TextStyle(
                            color: Colors.white, // Set your desired text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  viewNavigationMode: ViewNavigationMode.snap,
                  showDatePickerButton: true,
                  resourceViewSettings: const ResourceViewSettings(
                      visibleResourceCount: 4,
                      showAvatar: false,
                      displayNameTextStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
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
                  dataSource: _getCalendarDataSource(),
                  monthViewSettings: MonthViewSettings(
                      navigationDirection: MonthNavigationDirection.horizontal,
                      showAgenda: true,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                      agendaItemHeight: Get.height * 0.1,
                      numberOfWeeksInView: 5,
                      agendaViewHeight:
                          isLargeScreen ? Get.height * 0.18 : Get.height * 0.30,
                      monthCellStyle: const MonthCellStyle(
                        todayBackgroundColor: Color.fromARGB(255, 21, 163, 156),
                        textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 243, 239, 239)),
                      ),
                      agendaStyle: const AgendaStyle(
                        backgroundColor: Color.fromARGB(218, 249, 252, 253),
                        appointmentTextStyle: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(239, 236, 235, 234)),
                        dateTextStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 22,
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
        ),
      ),
    );
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    var targetResource = appointmentDragEndDetails.targetResource;
    var sourceResource = appointmentDragEndDetails.sourceResource;
    _showDialog(targetResource!, sourceResource!);
  }

  void _showDialog(
      CalendarResource targetResource, CalendarResource sourceResource) async {
    await showDialog(
      builder: (context) => AlertDialog(
        title: const Text("Dropped resource details"),
        contentPadding: const EdgeInsets.all(16.0),
        content: Text(
            "You have dropped the appointment from ${sourceResource.displayName} to ${targetResource.displayName}"),
        actions: <Widget>[
          TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      context: context,
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;
    return Column(
      children: [
        Container(
            width: calendarAppointmentDetails.bounds.width,
            height: calendarAppointmentDetails.bounds.height / 2,
            color: appointment.color,
            child: const Center(
              child: Icon(
                Icons.group,
                color: Colors.black,
              ),
            )),
        Container(
          width: calendarAppointmentDetails.bounds.width,
          height: calendarAppointmentDetails.bounds.height / 2,
          color: appointment.color,
          child: Text(
            '${appointment.subject}${DateFormat(' (hh:mm a').format(appointment.startTime)}-${DateFormat('hh:mm a)').format(appointment.endTime)}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
