import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:zenify_trip/Secreens/TravelerProvider.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';
import 'package:zenify_trip/login/login_Page.dart';
import '../modele/Event/Event.dart';
import '../modele/activitsmodel/activitesmodel.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/httpTransfer.dart';
import '../modele/planningmainModel.dart';
import 'package:get/get.dart';

import '../modele/traveller/TravellerModel.dart';
import 'EventTransporClient.dart';
import 'EventView.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class TravellerCalendarPage extends StatefulWidget {
  final String? group;
  final Traveller? tarveller;
  const TravellerCalendarPage({Key? key, this.group, this.tarveller})
      : super(key: key);

  @override
  _TravellerCalendarPageState createState() => _TravellerCalendarPageState();
}

class _TravellerCalendarPageState extends State<TravellerCalendarPage> {
  late DateTime startDate;
  bool isCalendarVisible = true;
  String dateString = DateTime.now().toString();
  late DateTime endDate;
  final CalendarController _controller = CalendarController();
  HTTPHandlerTransfer transporthandler = HTTPHandlerTransfer();
  HTTPHandlerActivites activiteshanhler = HTTPHandlerActivites();
  // var transferlist;
  List<Transport> transferList = [];
  List<Activity> Activityst = [];
  List<Transport> checkgroup = [];
  String? travellergroupId = "";
  @override
  void initState() {
    super.initState();
    _initializeTravelerData();
//     final travelerProvider =
//         Provider.of<TravelerProvider>(context, listen: false);
// // Future<String?> loadTravelerData = travelerProvider.loadTravelerData();
// //     final travellergroupIds = travelerProvider.groupid;



//     // Use await to get the result of loadTravelerData
//     final loadTravelerData = travelerProvider.loadTravelerData();

//     // Use the result to set travellergroupId
//     setState(() {
//       travellergroupId = loadTravelerData;
//     });
//     // Initialize travellergroupId using a FutureBuilder
//       _loadData();
//     fetchData();
  }
Future<void> _initializeTravelerData() async {
  final travelerProvider = Provider.of<TravelerProvider>(context, listen: false);

  try {
    final result = await travelerProvider.loadTravelerData();
    setState(() {
      travellergroupId = result;
    });
  } catch (error) {
    // Handle the error as needed
    print("Error initializing traveler data: $error");
  }

  // Other initialization code if needed
  _loadData();
  fetchData();
}







  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   fetchData();
  //   _loadData();
  //   final travelerProvider =
  //       Provider.of<TravelerProvider>(context, listen: false);
  //   final data = travelerProvider.loadTravelerData();
  //   final travellergroupIds = travelerProvider.groupid;

  //   print("$travellergroupId travellergroupId");
  //   setState(() {
  //     travellergroupId = travellergroupIds;
  //   });
  // }

  List<CalendarEvent> convertToCalendarEvents(
      List<Transport> transfers, List<Activity> activities) {
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
    for (var activty in activities) {
      events.add(CalendarEvent(
        title: "Ac",
        id: activty.id,
        description: "Activity Guid",
      
        type: activty,
             startTime: activty.departureDate ?? DateTime.now(),
      
        endTime: activty.returnDate ?? DateTime.now().add(Duration(hours: 5)),
        color: Color.fromARGB(214, 235, 6, 75),
      ));
    }
    return events;
  }

  Future<void> fetchData() async {
    try {
      // Fetch transferList
      transferList = await transporthandler
          .fetchData("/api/transfers-mobile/touristgroups/$travellergroupId");
    } catch (e) {
      // Handle error for transferList
      print("Error fetching transfer data: $e");
      // Handle error for transferList as needed, e.g., show an error message.
    }

    try {
      // Fetch Activityst with a specific touristGroupId
      Activityst = await activiteshanhler.fetchData(
          "/api/activities?filters[touristGroupId]=$travellergroupId");
    } catch (e) {
      // Handle error for Activityst
      print("Error fetching activity data: $e");
      // Handle error for Activityst as needed, e.g., show an error message.
    }

    // Now you have both transferList and Activityst fetched and can use them as needed.
    setState(() {
      List<CalendarEvent> events =
          convertToCalendarEvents(transferList, Activityst);
      // Update any state variables with the events.
    });
  }

  String serializeTransportData(List<Transport> data) {
    // Convert a list of Transport objects to a JSON string
    final List<Map<String?, dynamic>> transportList =
        data.map((transport) => transport.toJson()).toList();
    return json.encode(transportList);
  }

  List<Transport> parseTransportData(String jsonString) {
    // Parse a JSON string into a list of Transport objects
    final List<dynamic> transportList = json.decode(jsonString);
    return transportList.map((json) => Transport.fromJson(json)).toList();
  }

  Future<DataResult> _loadData() async {
    // try {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // // Attempt to load data from local storage
    // String? savedData = prefs.getString('transportData');
    // checkgroup = parseTransportData(savedData!);
    // print("${checkgroup[0].touristGroupId} checkgroup[0].touristGuideId");
    // print("$travellergroupId widget.group");
    // if (checkgroup[0].touristGroupId == widget.group && savedData != null) {
    //   print(savedData);
    //   // Data found in local storage, parse it and return
    //   setState(() {
    //     transferList = parseTransportData(savedData);
    //     print("data saved");
    //   });
    //   return transferList;
    // }
    try {
      // Fetch transferList
      transferList = await transporthandler
          .fetchData("/api/transfers-mobile/touristgroups/$travellergroupId");
    } catch (e) {
      // Handle error for transferList
      print("Error fetching transfer data: $e");
      // Handle error for transferList as needed, e.g., show an error message.
    }

    try {
      // Fetch Activityst with a specific touristGroupId
      Activityst = await activiteshanhler.fetchData(
          "/api/activities?filters[touristGroupId]=$travellergroupId");
    } catch (e) {
      // Handle error for Activityst
      print("Error fetching activity data: $e");
      // Handle error for Activityst as needed, e.g., show an error message.
    }

    // Save the fetched data to local storage
    // prefs.setString('transportData', serializeTransportData(transferList));

    return DataResult(transfers: transferList, activities: Activityst);
    // } catch (e) {
    //   await Future.delayed(Duration(seconds: 1));
    //   if (transferList == null || transferList.isEmpty) {
    //     Get.dialog(
    //       AlertDialog(
    //         title: Text('No Transfers'),
    //         content: Text('There are no transfers in your group.'),
    //         actions: [
    //           ElevatedButton(
    //             onPressed: () {
    //               // Close the alert dialog
    //               Get.back();
    //               // Navigate to MyLogin page and remove the current screen
    //               // Get.offAll(TravellerFirstScreen());
    //             },
    //             child: Text('OK'),
    //           ),
    //         ],
    //       ),
    //     );
    //   }

    //   // Handle any errors that might occur during data fetching
    //   await Future.delayed(Duration(seconds: 1));

    //   // Handle any errors that might occur during data fetching
    //   print("Error loading data: $e $travellergroupId");
    //   return DataResult(transfers: [], activities: []);
    // }
  }

  // Future<List<Transport>> _loadData() async {
  //   try {
  //     // Fetch data using transporthandler and API endpoint
  //     transferList = await transporthandler
  //         .fetchData("/api/transfers-mobile/touristgroups/$travellergroupId");
  //     print(transferList[0].id);
  //     // Update the transferlist with fetched data

  //     return transferList; // Return the fetched data
  //   } catch (e) {
  //     if (transferList == null || transferList.isEmpty) {
  //       Get.dialog(
  //         AlertDialog(
  //           title: Text('No Transfers'),
  //           content: Text('There are no transfers in your group.'),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Close the alert dialog
  //                 Get.back();
  //                 // Navigate to MyLogin page and remove the current screen
  //                 Get.offAll(TravellerFirstScreen());
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       ); // Navigate to MyLogin page if transferlist is empty
  //     }
  //     // Handle any errors that might occur during data fetching
  //     print("Error loading data: $e $travellergroupId");
  //     return []; // Return an empty list in case of an error
  //   }
  // }
  CalendarDataSource _getCalendarDataSource(
      List<Transport> transports, List<Activity> activities) {
    List<Appointment> appointments = [];

    // Check if transports and activities are not null
    if (transports != null) {
      for (Transport transfer in transports) {
        appointments.add(Appointment(
          id: transfer.id,
          notes: transfer.note,
          recurrenceId: transfer,
          startTime: transfer.date ?? DateTime.now(),
          subject: '🚍 from ${transfer.from} to ${transfer.to}',
          endTime: (transfer.date ?? DateTime.now())
              .add(Duration(hours: transfer.durationHours ?? 0)),
          color: Color.fromARGB(255, 254, 174, 13),
        ));
      }
    }

    // Check if activities are not null
    if (activities != null) {
      for (Activity activity in activities) {
        appointments.add(Appointment(
          id: activity.id,
          notes: activity.name,
          recurrenceId: activity,
          startTime: activity.departureDate ?? DateTime.now(),
          subject: '${activity.name ?? 'activity'}',
          endTime:
              activity.returnDate ?? DateTime.now().add(Duration(hours: 5)),
          color: Color.fromARGB(255, 189, 2, 2),
        ));
      }
    }

    return AppointmentDataSource(appointments);
  }

  // CalendarDataSource _getCalendarDataSource(List<Transport> tansports, List<Activity> activities) {
  //   List<Appointment> appointments = [];

  //   for (Transport transfer in tansports) {
  //     appointments.add(Appointment(
  //         // isAllDay: transfer.confirmed ?? true,
  //         id: transfer.id,
  //         notes: transfer.note,
  //         recurrenceId: transfer,
  //         startTime: transfer.date ?? DateTime.now(),
  //         subject: '🚍 from ${transfer.from} to ${transfer.to}',
  //         endTime:
  //           (transfer.date ?? DateTime.now()).add(Duration(hours: transfer.durationHours ?? 0)),
  //         color: Color.fromARGB(255, 228, 158, 6)));
  //   }
  //   for (Activity activity in activities) {
  //     appointments.add(Appointment(
  //         // isAllDay: transfer.confirmed ?? true,
  //         id: activity.id,
  //         notes: activity.name,
  //         recurrenceId: activity,
  //         startTime: activity.departureDate ?? DateTime.now(),
  //         subject: '${activity.name ?? 'activity'}',
  //         endTime:
  //             activity.returnDate ?? DateTime.now().add(Duration(hours:5)),
  //         color: Color.fromARGB(255, 170, 3, 3)));
  //   }
  //   return AppointmentDataSource(appointments);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //       'Calendar Page $airplaneEmoji $thumbsUpMediumSkinToneEmoji '),
        //   actions: [
        //     Row(
        //       children: [
        //         // IconButton(
        //         //   onPressed: () {
        //         //     showSearch(
        //         //         // context: context, delegate: SearchActivitytemp());
        //         //   },
        //         //   icon: Icon(Icons.search_sharp),
        //         // ),
        //         // IconButton(
        //         //   onPressed: () {
        //         //     setState(() {
        //         //  isCalendarVisible = !isCalendarVisible;
        //         //       fetchData();
        //         //     });
        //         //   },
        //         //   icon: Visibility(
        //         //     visible: isCalendarVisible,
        //         //     child: Icon(Icons.remove_red_eye),
        //         //     replacement: Icon(Icons.visibility_off),
        //         //   ),
        //         // )
        //         // IconButton(
        //         //   onPressed: () {
        //         //     setState(() {
        //         //       isLoading = !isLoading;
        //         //     });
        //         //   },
        //         //   icon: Icon(Icons.remove_red_eye),
        //         // )
        //       ],
        //     ),
        //   ],
        // ),

        body: RefreshIndicator(
      onRefresh: fetchData,
      child: ListView(
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       // Toggle the visibility flag
          //       isCalendarVisible = !isCalendarVisible;
          //     });
          //   },
          //   child:
          //       Text(isCalendarVisible ? 'only transfer Days' : 'Show Calendar All Days'),
          // ),
          Container(
            height: Get.height * 0.88,
            child: SfCalendar(
              todayHighlightColor: Color.fromARGB(255, 241, 158, 3),
              todayTextStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 238, 234, 238)),
              //
              monthCellBuilder: monthCellBuilder,
              headerHeight: 40,
              controller: _controller,
              view: CalendarView.schedule,
              scheduleViewSettings: ScheduleViewSettings(
// hideEmptyScheduleWeek : isCalendarVisible,
                appointmentItemHeight: 80,
                appointmentTextStyle: TextStyle(
                  color: Color.fromARGB(
                      255, 242, 237, 237), // Set the text color to red
                  fontSize: 16, // Set the font size
                  fontWeight: FontWeight.w600, // Set the font weight to bold
                  fontStyle: FontStyle.normal, // Set the font style to italic
                  // Add underline decoration
                ),
                // Customize various schedule view settings here
                dayHeaderSettings: DayHeaderSettings(
                  dayFormat: 'EEE, MMM dd', // Format of the day header
                ),
              ),
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
              scheduleViewMonthHeaderBuilder: (
                BuildContext context,
                ScheduleViewMonthHeaderDetails headerDetails,
              ) {
                // You can return a custom widget here to be displayed as the header.

                return SvgPicture.asset(
                  'assets/Frame.svg',

                  // color: Color.fromARGB(255, 49, 8, 236),
                ); //     SizedBox(height: 8.0), // Add some spacing
                //     Text(
                //       'Other Information Here',
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.white,
                //       ),
              },
              viewNavigationMode: ViewNavigationMode.snap,
// onTap: calendarTappede,
              onTap: (CalendarTapDetails details) {
                calendarTapped(
                    context, details); // Call your calendarTapped function
              },
              showDatePickerButton: true,
              resourceViewSettings: ResourceViewSettings(
                  visibleResourceCount: 4,
                  showAvatar: false,
                  displayNameTextStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Color.fromARGB(255, 250, 248, 246),
                      fontWeight: FontWeight.w400)),

              allowedViews: <CalendarView>[
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
              dataSource: _getCalendarDataSource(transferList, Activityst),
// loadMoreWidgetBuilder: loadMoreWidget,
              monthViewSettings: MonthViewSettings(
                  navigationDirection: MonthNavigationDirection.horizontal,
                  showAgenda: true,
                  // appointmentDisplayMode:
                  //     MonthAppointmentDisplayMode.indicator,
                  agendaItemHeight: Get.height * 0.1,
                  numberOfWeeksInView: 5,
                  // agendaViewHeight: isLargeScreen
                  //     ? Get.height * 0.18
                  //     : Get.height * 0.28,
                  monthCellStyle: MonthCellStyle(
                    todayBackgroundColor: Color.fromARGB(255, 97, 1, 42),
                    textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 63, 1, 1)),
                  ),
                  agendaStyle: AgendaStyle(
                    backgroundColor: Color.fromARGB(255, 2, 91, 173),
                    appointmentTextStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 234, 228, 235)),
                    dateTextStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    dayTextStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 252, 251, 252)),
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  void calendarTappede(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      // final Meeting appointmentDetails = details.appointments[0];
      // _subjectText = appointmentDetails.eventName;
      // _dateText = DateFormat('MMMM dd, yyyy')
      //     .format(appointmentDetails.from)
      //     .toString();
      // _startTimeText =
      //     DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      // _endTimeText =
      //     DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      // if (appointmentDetails.isAllDay) {
      //   _timeDetails = 'All day';
      // } else {
      //   _timeDetails = '$_startTimeText - $_endTimeText';
      // }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          't',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("t",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: [Text("Id:")],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('close'))
              ],
            );
          });
    }
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    var length = details.appointments.length;
    if (details.appointments.isNotEmpty) {
      return Container(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  details.date.day.toString(),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.event_available_rounded,
                  color: Colors.red,
                  size: 20,
                ),
                (Platform.isAndroid || Platform.isIOS)
                    ? Column(
                        children: [
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text(
                            '$length',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.deepPurple),
                          )
                        ],
                      )
                    : SizedBox()
              ],
            )
          ],
        ),
      );
    }
    return Container(
      child: Text(
        details.date.day.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget loadMoreWidget(
      BuildContext context, LoadMoreCallback loadMoreAppointments) {
    return FutureBuilder<void>(
      initialData: 'loading',
      future: loadMoreAppointments(),
      builder: (context, snapShot) {
        return Container(
            alignment: Alignment.center, child: CircularProgressIndicator());
      },
    );
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

class DataResult {
  List<Transport> transfers;
  List<Activity> activities;

  DataResult({required this.transfers, required this.activities});
}
