import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../../HTTPHandlerObject.dart';
import '../../modele/httpTravellerbyid.dart';
import '../../modele/traveller/TravellerModel.dart';
import 'TravellerCalender.dart';
import 'package:get/get.dart';

class TravellerFirstScreen extends StatefulWidget {
  @override
  _TravellerFirstScreenState createState() => _TravellerFirstScreenState();
}

class _TravellerFirstScreenState extends State<TravellerFirstScreen> {
  late Traveller traveller; // Declare the Traveller variable
  final Travelleruserid = HTTPHandlerTravellerbyId();
  HTTPHandler<Traveller> handler = HTTPHandler<Traveller>();
  final storage = new FlutterSecureStorage();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadDataTraveller(); // Load traveller data when the screen initializes
  }

  Future<Traveller> _loadDataTraveller() async {
    final userId = await storage.read(key: "id");

    // String? accessToken = await getAccessToken();
    // print('${widget.token} token');

    final travellerdetail =
        await handler.fetchData("/api/travellers/UserId/$userId", Traveller.fromJson);

    setState(() {
      traveller = travellerdetail;
      print(travellerdetail.id);
      isLoading = false;
      // _loadDatagroup();
    });

    return travellerdetail;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          child: Center(
            child: FutureBuilder(
              future: Future.delayed(Duration(seconds: 5)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator or any other widget while waiting
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 219, 10, 10),
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 24, 10, 221)),
                    ),
                  );
                } else {
                  // After the delay, show the "Submit" button
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: Get.width * 0.7,
                        // ),
                        Text('session Tim out.... ',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Color.fromARGB(255, 90, 3, 203))),
                        ElevatedButton(
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .red, // Change the button's background color
                            onPrimary: Colors.white, // Change the text color
                            textStyle: TextStyle(
                                fontSize: 16), // Change the text style
                            padding: EdgeInsets.symmetric(
                                horizontal: 16), // Adjust the padding
                            minimumSize: Size(120,
                                40), // Set a minimum width and height for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
                          ),
                          onPressed: () async {
                            await storage.delete(key: "access_token");
                            // Get.to(LoginView());
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Traveller First Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Traveller First Screen!',
                style: TextStyle(fontSize: 20),
              ),
              if (traveller != null) // Display traveller data if available
                Text(
                  'Traveller ID: ${traveller.id}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add any navigation logic here
                  Get.to(TravellerCalendarPage(
                    group: traveller.touristGroupId,
                  ));
                },
                child: Text('Navigate '),
              ),
            ],
          ),
        ),
      );
    }
  }
}