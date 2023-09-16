import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/Secreens/ConcentricAnimationOnboarding.dart';
import 'package:zenify_trip/Secreens/CustomCalendarDataSource.dart';
import 'package:zenify_trip/Secreens/Notification/PushNotificationScreen.dart';
import 'package:zenify_trip/Secreens/Profile/editprofile.dart';
import 'package:zenify_trip/guide_Screens/calendar/transfert_data.dart';
import 'package:zenify_trip/constent.dart';
import 'package:zenify_trip/modele/Event/Event.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:zenify_trip/modele/planningmainModel.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';
import 'package:flutter_svg/svg.dart';

import 'eventdetail_test.dart';

class PlanningScreen extends StatefulWidget {
  String? Plannigid;
  TouristGuide? guid;

  @override
  PlanningScreen(this.Plannigid, this.guid, {Key? key}) : super(key: key);

  get handleEventSave => null;
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
    bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }
  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  void _onRailItemSelected(int index) {
    // Implement navigation based on the selected rail item index
    switch (index) {
      case 0: // Example: Navigate to Home page
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1: // Example: Navigate to Settings page
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
      // Add more cases for other pages
    }
  }

  final storage = const FlutterSecureStorage();
  final CalendarController _controller = CalendarController();

  String? date;

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
  Color cardcolor = const Color.fromARGB(255, 21, 19, 1);
  bool loading = false;

  get selectedPlanning => PlanningMainModel();

  TouristGuide? get selectedTouristGuide => TouristGuide();
  // int completedCount = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataAndOrganizeEvents();
  }

  List<CalendarEvent> convertToCalendarEvents(
    List<Transport> transfers,
  ) {
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
        color: const Color.fromARGB(200, 2, 152, 172),
      ));
    }
    return events;
  }

  Future<void> fetchData() async {
    try {
      transferList = await fetchTransfers(
          "/api/transfers/touristGuidId/${widget.guid?.id}");
      setState(() {
        List<CalendarEvent> events = transferList.cast<CalendarEvent>();
      });
    } catch (e) {
      // Handle error
      print("Handle error $e");
    }
  }

  Future<Map<String, List<dynamic>>> fetchDataAndOrganizeEvents() async {
    try {
      List<Transport> transfersList = await fetchTransfers(
        "/api/transfers/touristGuidId/${widget.guid!.id}",
      );

      List<CalendarEvent> events =
          transfersList.map((transport) => TransportEvent(transport)).toList();

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
        'transfers': transfersList,
      };
    } catch (e) {
      // Handle error
      print("Error fetching data111: $e");
      rethrow;
    }
  }

  void handleEventSave(TransportEvent updatedEvent) {
    setState(() {
      // Update the event list with the changes
      int index = transferList
          .indexWhere((element) => element.id == updatedEvent.transport.id);
      if (index != -1) {
        transferList[index] = updatedEvent.transport;
      }
    });
  }

  CalendarDataSource _getCalendarDataSource() {
    List<CalendarEvent> events = [];
    eventsByDate.forEach((date, eventList) {
      events.addAll(eventList);
    });

    // Create an instance of CalendarDataSource with the events list
    return CustomCalendarDataSource(events, eventColors);
  }

  Future<List<Transport>> fetchTransfers(String url) async {
    List<Transport> transferList = [];
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);
final response = await http.get(
  Uri.parse(url), // Positional argument (URL)
  headers: {"Authorization": "Bearer $token"}, // Named argument (headers)
);


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
  1: Expanded(
    child: Column(
      children: [
        SizedBox(height: 14.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
      TransportEvent event =
          calendarTapDetails.appointments![0] as TransportEvent;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventView(
            event: event,
            onSave: handleEventSave, // Pass the method
          ),
        ),
      );
    }
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
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                   DrawerHeader(
  decoration: BoxDecoration(
    color: Colors.blue,
  ),
  margin: EdgeInsets.only(bottom: 8.0),
  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
  duration: Duration(milliseconds: 250),
  curve: Curves.fastOutSlowIn,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // Customize the content of the drawer header
      Text(
        'Zenify Trip',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      SizedBox(height: 8),
      Text(
        'Additional Info',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ],
  ),
),

                    // Rest of the drawer items
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Calendar'),
                      onTap: () {
                        // Handle drawer item click
                        Navigator.pop(context); // Close the drawer
                      },
                    ),

                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profil'),
                      onTap: () {
                        // Handle drawer item click
                        Get.to(const MainProfile()); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Send Notification'),
                      onTap: () {
                        // Handle drawer item click
                        Get.to(PushNotificationScreen(widget.guid));// Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.more_horiz),
                      title: const Text('More'),
                      onTap: () {
                        // Handle drawer item click
                        Get.to(
                            const ConcentricAnimationOnboarding()); // Close the drawer
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  transform: Matrix4.translationValues(_isDrawerOpen ? 200 : 0, 0, 0),
  child: RefreshIndicator(
    onRefresh: fetchData,
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
                  headerHeight: 40,
                  controller: _controller,
                  view: CalendarView.schedule,
                  scheduleViewMonthHeaderBuilder: (BuildContext context,
                      ScheduleViewMonthHeaderDetails details) {
                    // You can return a custom widget here to be displayed as the header.
                    return Container(
                      color: const Color.fromARGB(255, 184, 139,
                          243), // Set your desired background color
                      child: const Center(
                        child: Text(
                          'Zenify Trip', // Set your desired header text
                          style: TextStyle(
                            color: Colors.white, // Set your desired text color
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
      // drawer: Container(
      //   width: 200,
      //   child: Drawer(
      //     child: Column(
      //       children: [
      //         Container(
      //           height: 100,
      //           color: Colors.blue,
      //           child: const Center(
      //             child: Text(
      //               'Drawer Header',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.home),
      //           title: const Text('Home'),
      //           onTap: () {
      //             // Handle drawer item click
      //             _toggleDrawer();
      //           },
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.star),
      //           title: const Text('Favorites'),
      //           onTap: () {
      //             // Handle drawer item click
      //             _toggleDrawer();
      //           },
      //         ),
      //         ListTile(
      //           leading: const Icon(Icons.settings),
      //           title: const Text('Settings'),
      //           onTap: () {
      //             // Handle drawer item click
      //             _toggleDrawer();
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
