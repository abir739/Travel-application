import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:zenify_trip/modele/Event/Event.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'package:zenify_trip/modele/activitsmodel/activitesmodel.dart';

import '../modele/accommodationsModel/accommodationModel.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/activitsmodel/activitiesCategoryModel.dart';
import 'package:get/get.dart';
import '../modele/transportmodel/transportModel.dart';
import 'package:zenify_trip/Secreens/CustomCalendarDataSource.dart';
import 'AccoummondationSecreenDetail.dart';
import 'EventView.dart';
import '../constent.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class PlanningScreen extends StatefulWidget {
  String? Plannigid;
  TouristGuide? guid;
  @override
  PlanningScreen(this.Plannigid, this.guid, {Key? key}) : super(key: key);
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final storage = const FlutterSecureStorage();
  final CalendarController _controller = CalendarController();
  String? _headerText = '';
  String? date;
  double? _width = 0.0, cellWidth = 0.0;
  String _string = '';
  List<Activity> activityList = [];
  List<Accommodations> accommodationList = [];
  List<Transport> transferList = [];
  int selectedIndex = 0;
  double activityProgress = 0.0;
  Map<CalendarEvent, Color> eventColors = {};
  double gethigth = Get.height * 0.185 / Get.height;

  bool isweek = true;
  List<CalendarEvent> CalendarEvents = [];
  String dateString = DateTime.now().toString();
  // DateTime initialDate = DateTime.parse(dateString);
  CalendarController calendarController = CalendarController();
  List<CalendarEvent> calendarEvents = [];
  Map<DateTime, List<CalendarEvent>> eventsByDate = {};
  final List<String> viewOptions = ['Day', 'Week', 'Month', 'All DAta'];
  String selectedView = 'Month'; // Default selected view is Month
  Color cardcolor = Color.fromARGB(255, 21, 19, 1);
  bool loading = false;
  // int completedCount = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataAndOrganizeEvents();
  }

  // double calculateCompletedActivities(List<Activity> activities) {
  //   // int completedCount = 0;

  //   for (var activity in activities) {
  //     completedCount++;
  //   }

  //   return completedCount.toDouble();
  // }

  List<CalendarEvent> convertToCalendarEvents(
    List<Accommodations> accommodations,
    List<Activity> activities,
    List<Transport> transfers,
  ) {
    List<CalendarEvent> events = [];

    // Convert accommodations to events
    for (var accommodation in accommodations) {
      events.add(CalendarEvent(
        title: "Accom: ${accommodation.note}",
        description: "A-T",
        id: accommodation.id,
        type: accommodation,
        startTime: accommodation.date,
        endTime: accommodation.date!
            .add(Duration(days: accommodation.countNights ?? 0)),
        color: Color.fromARGB(199, 245, 2, 253),
      ));
    }
    for (var activity in activities) {
      // Assuming 60 as total count
      events.add(CalendarEvent(
        displayNameTextStyle: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        title: "A-c :${activity.name}",
        id: activity.id,
        description: "Activity ${activity.name}",
        startTime: activity.departureDate,
        type: activity,
        endTime: activity.returnDate,
        color: Color.fromARGB(227, 239, 176, 3),
      ));
    }

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
      activityList = await fetchActivities(
          "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}");
      accommodationList = await fetchAccommodations(
          "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}");
      transferList = await fetchTransfers(
          "/api/transfers/touristGuidId/${widget.guid?.id}");
      setState(() {
        List<CalendarEvent> events = convertToCalendarEvents(
            accommodationList, activityList, transferList);
      });
    } catch (e) {
      // Handle error
      print("Handle error $e");
    }
  }

  Future<Map<String, List<dynamic>>> fetchDataAndOrganizeEvents() async {
    try {
      List<Activity> activitiesList = await fetchActivities(
        "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}",
      );
      List<Accommodations> accommodationsList = await fetchAccommodations(
        "/api/plannings/activitiestransfertaccommondation/047c80d9-14c8-4735-b355-d8f5beaa90e6",
      );
      List<Transport> transfersList = await fetchTransfers(
        "/api/transfers/touristGuidId/${widget.guid!.id}",
      );

      List<CalendarEvent> events = convertToCalendarEvents(
        accommodationsList,
        activitiesList,
        transfersList,
      );

      for (var event in events) {
        if (event.startTime != null) {
          DateTime dateKey = DateTime(
            event.startTime!.year,
            event.startTime!.month,
            event.startTime!.day,
          );

          if (!eventsByDate.containsKey(dateKey)) {
            eventsByDate[dateKey] = [];
          }
          eventsByDate[dateKey]!.add(event);
        } else {
          print(event.description);
        }
      }

      return {
        'activities': activitiesList,
        'accommodations': accommodationsList,
        'transfers': transfersList,
      };
    } catch (e) {
      // Handle error
      print("Error fetching data111: $e");
      throw e;
    }
  }

  CalendarDataSource _getCalendarDataSource() {
    List<CalendarEvent> events = [];
    eventsByDate.forEach((date, eventList) {
      events.addAll(eventList);
    });

    // Create an instance of CalendarDataSource with the events list
    return CustomCalendarDataSource(events, eventColors);
  }

  Future<List<Activity>> fetchActivities(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);

    List<Activity> activityList = [];

    final response = await http.get(headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    }, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['activities'];
      print("resultList $resultList");
      activityList = resultList.map((e) => Activity.fromJson(e)).toList();
      return activityList;
    } else {
      throw Exception('${response.statusCode} err');
    }
  }

  Future<List<Accommodations>> fetchAccommodations(String url) async {
    List<Accommodations> accommodationList = [];
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");

    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);
    final response = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['accommodations'];
      accommodationList =
          resultList.map((e) => Accommodations.fromJson(e)).toList();
      return accommodationList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<List<Transport>> fetchTransfers(String url) async {
    List<Transport> transferList = [];
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");

    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);
    final response = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data["results"];
      transferList = resultList.map((e) => Transport.fromJson(e)).toList();
      return transferList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  final Map<int, Widget> segmentWidgets = {
    0: const Expanded(
      child: Column(
        children: [
          SizedBox(height: 14.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Text('Accommodations'),
          ),
          SizedBox(height: 14.0),
        ],
      ),
    ),
    3: const Expanded(
      child: Column(
        children: [
          SizedBox(height: 14.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Activity'),
          ),
          SizedBox(height: 14.0),
        ],
      ),
    ),
    1: Expanded(
      child: Column(
        children: [
          SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Transfers'),
          ),
          SizedBox(height: 14.0),
        ],
      ),
    ),
  };
  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      CalendarEvent event =
          calendarTapDetails.appointments![0] as CalendarEvent;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EventView(event: event)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;
    return Container(
      color: Color.fromARGB(236, 238, 239, 242),
      // decoration: BoxDecoration(
      //   // image: DecorationImage(
      //   //     image: AssetImage('assets/istockphoto-1045809116-612x612.jpg'), fit: BoxFit.cover),
      // ),
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
            onRefresh: fetchData,
            child: ListView(
              children: [
                Container(
                  height: Get.height * 0.88,
                  child: SfCalendar(
                    todayHighlightColor: Color.fromARGB(255, 242, 186, 3),
                    todayTextStyle: TextStyle(
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
                              ? Color.fromARGB(255, 245, 242, 242)
                              : Color.fromARGB(255, 179, 228, 236),
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
                                color: details.visibleDates
                                        .contains(details.date)
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
                                color:
                                    details.visibleDates.contains(details.date)
                                        ? Color.fromARGB(255, 87, 6, 134)
                                        : Color.fromARGB(255, 87, 6, 134),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    headerHeight: 38,
                    controller: _controller,
                    view: CalendarView.month,
                    // onViewChanged: (ViewChangedDetails viewChangedDetails) {
                    //   _headerText = DateFormat('MMMM yyyy', 'fr')
                    //       .format(viewChangedDetails
                    //       .visibleDates[viewChangedDetails.visibleDates
                    //       .length ~/ 2])
                    //       .toString();
                    //   _string = _headerText![0].toUpperCase() +
                    //       _headerText!.substring(1);
                    //   SchedulerBinding.instance!.addPostFrameCallback((
                    //       duration) {
                    //     setState(() {});
                    //   });
                    // },
                    scheduleViewMonthHeaderBuilder: (BuildContext context,
                        ScheduleViewMonthHeaderDetails details) {
                      // You can return a custom widget here to be displayed as the header.
                      return Container(
                        color: const Color.fromARGB(255, 215, 8,
                            46), // Set your desired background color
                        child: const Center(
                          child: Text(
                            'Custom Header', // Set your desired header text
                            style: TextStyle(
                              color:
                                  Colors.white, // Set your desired text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    viewNavigationMode: ViewNavigationMode.snap,
                    onTap: (CalendarTapDetails details) {
                      calendarTapped(context,
                          details); // Call your calendarTapped function
                    },
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
                      // CalendarView.timelineDay,
                      // CalendarView.timelineWeek,
                      // CalendarView.timelineWorkWeek,
                      // CalendarView.timelineMonth,
                      CalendarView.schedule
                    ],
                    initialDisplayDate: DateTime.parse(dateString),
                    dataSource: _getCalendarDataSource(),
                    monthViewSettings: MonthViewSettings(
                        navigationDirection:
                            MonthNavigationDirection.horizontal,
                        showAgenda: true,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                        agendaItemHeight: Get.height * 0.09,
                        numberOfWeeksInView: 5,
                        agendaViewHeight: isLargeScreen
                            ? Get.height * 0.18
                            : Get.height * 0.28,
                        monthCellStyle: const MonthCellStyle(
                          todayBackgroundColor: Colors.red,
                          textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
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
          )),
    );
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    var targetResource = appointmentDragEndDetails.targetResource;
    var sourceResource = appointmentDragEndDetails.sourceResource;
    _showDialog(targetResource!, sourceResource!);
  }

  void _showAppointmentDetails(Appointment appointment) {
    // Implement code to show the details of the clicked appointment
    // This could involve opening a dialog, a new screen, or any other UI mechanism
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appointment.subject ?? "subject"),
          content: Text(appointment.notes ?? "notes"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(
      CalendarResource targetResource, CalendarResource sourceResource) async {
    await showDialog(
      builder: (context) => AlertDialog(
        title: const Text("Dropped resource details"),
        contentPadding: const EdgeInsets.all(16.0),
        content: Text("You have dropped the appointment from " +
            sourceResource.displayName +
            " to " +
            targetResource.displayName),
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
            child: Center(
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
            appointment.subject +
                DateFormat(' (hh:mm a').format(appointment.startTime) +
                '-' +
                DateFormat('hh:mm a)').format(appointment.endTime),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
