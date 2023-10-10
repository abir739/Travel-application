import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenify_trip/modele/TouristGuide.dart';

import '../../services/constent.dart';
import '../../modele/activitsmodel/httpTransportid.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import '../../modele/httpNotificationId.dart';
import '../../modele/httpTouristguidByid.dart';
import '../../modele/httpTravellerbyid.dart';
import '../../modele/transportmodel/transportModel.dart';
import '../../theme.dart';
import '../components/rating,.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String? id;
  final String? ObjectType;
  final String? idt;
  const ActivityDetailScreen({this.id, this.ObjectType, this.idt, super.key});

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final NotificationH =
      HTTPHandlerNotificationId(); // Initialize your HTTP handler
  late PushNotification activityDetails;
  final trasferhandler = HTTPHandlerTrasportId();
  String? ids;
  String? idt;
  @override
  void initState() {
    super.initState();
    // final Map<String, dynamic>? arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ids    = arguments?['id'] as String?;
    // // Fetch activity details using the provided ID
    // print("${widget.id} widget.id" );
    // fetchActivityDetails(ids);
    // final Map<String, dynamic>? arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ids = arguments?['id'] as String?;
    // print("ids $ids");
    // Fetch activity details using the extracted 'id'
    fetchActivityDetails(ids);
    fetchtransferDetails(idt);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract the 'id' value from the route argumentsR
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    ids = arguments?['id'] as String?;
    idt = arguments?['idT'] as String?;
    print("ids $ids");
    // Fetch activity details using the extracted 'id'
    fetchActivityDetails(ids);
    fetchtransferDetails(idt);
  }

//   Future<PushNotification> fetchActivityDetails(String id) async {
//     try {
//       // Use your HTTP handler to fetch activity details by ID
//       final activityDetails = await NotificationH.fetchData(id);
//       // Update the state or display the activity details here
//     } catch (error) {
//       // Handle any errors or show an error message
//     }
// return activityDetails;
//   }
// Future<void> fetchActivityDetails(String id) async {
//     try {
//       final details = await NotificationH.fetchData(id);
//       setState(() {
//         activityDetails = details as PushNotification;
//       });
//     } catch (error) {
//       // Handle any errors or show an error message
//     }
//   }
  Future<PushNotification> fetchActivityDetails(String? id) async {
    try {
      final details =
          await NotificationH.fetchData("/api/push-notificationsMobile/$ids");

      return details; // Return the fetched data
    } catch (error) {
      // Handle any errors or show an error message
      throw error; // You should throw the error to propagate it
    }
  }

  Future<Transport> fetchtransferDetails(String? id) async {
    try {
      final transport =
          await trasferhandler.fetchData("/api/transfers-mobile/$idt");
      print("${transport.from}from");
      print("${transport.touristGuide?.id}from");
      return transport; // Return the fetched data
    } catch (error) {
      // Handle any errors or show an error message
      throw error; // You should throw the error to propagate it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Detail'),
      ),
      body: Container(
        child: Container(
          child: Container(
            child: buildTransportDetails(),
//  Padding(
//               padding: EdgeInsets.all(40.0),
//               child: Column(
//                 children: [
//                   buildActivityDetails(),
//                   SizedBox(height: 16.0),

//                   SizedBox(height: 16.0),

//                 ],
//               ),
//             ),
          ),
        ),
      ),
    );
  }

  Widget buildActivityDetails() {
    return FutureBuilder<PushNotification>(
      future: fetchActivityDetails(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final details = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.ObjectType ?? 'No Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                details?.message ?? 'No Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                details?.title ?? 'No Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget TravelCard(Transport transfer) => Container(
        child: Stack(
          children: [
            // Container(
            //   height: double.,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image(
            //       image: AssetImage("assets/404.png"),
            //       fit: BoxFit.fitWidth,
            //     ),
            //   ),
            // ),
            Positioned(
                right: 0,
                top: 80,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: Icon(
                      Icons.favorite_rounded,
                      size: 20,
                      color: kAppTheme.highlightColor,
                    ),
                    onPressed: () {})),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withAlpha(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "From ",
                          style: kAppTheme.textTheme.displaySmall,
                        ),
                        Text(
                          transfer.from ?? " No Data",
                          style: kAppTheme.textTheme.displaySmall,
                        ),
                        Text(
                          "  to  ",
                          style: kAppTheme.textTheme.displaySmall,
                        ),
                        Text(
                          transfer.to ?? " No Data",
                          style: kAppTheme.textTheme.displaySmall,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${transfer.touristGuide?.name} has update or create  " ??
                          " No Data",
                      style: kAppTheme.textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [Rating(rating: 4.6)],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
  Widget buildTransportDetails() {
    return FutureBuilder<Transport>(
      future: fetchtransferDetails(idt),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final transport = snapshot.data;
          return TravelCard(transport!);
//  Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               Text(
//                 'Transport Details',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'From: ${transport?.from ?? 'No Data'}',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'To: ${transport?.to ?? 'No Data'}',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'At: ${formatDateTimeInTimeZone(transport?.date ?? DateTime.now()) ?? 'No Data'}',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'It Takes: ${transport?.durationHours ?? 'No Data'} H',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           );
        }
      },
    );
  }
}
