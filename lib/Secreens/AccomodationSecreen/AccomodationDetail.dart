import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:zenify_trip/modele/accommodationsModel/accommodationModel.dart';
import 'package:zenify_trip/modele/activitsmodel/httpAcccomodationId.dart';


class accomodationDetailsSecreen extends StatefulWidget {
  Accommodations? accomodation;
  String? token;

  accomodationDetailsSecreen(this.accomodation, this.token, {Key? key})
      : super(key: key);

  @override
  _accomodationDetailsSecreenState createState() =>
      _accomodationDetailsSecreenState();
}

class _accomodationDetailsSecreenState extends State<accomodationDetailsSecreen> {
  HTTPHandlerAccomodationId AccomodationHandler = HTTPHandlerAccomodationId();
  late Accommodations  _accomodations;
  String? baseUrl = "";
  String token = "";
  bool isLoading = true;
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;
  Future<Accommodations> _loadData() async {
    // String? accessToken = await getAccessToken();
    print('${widget.token} token');
    final updatedData = await AccomodationHandler.fetchData(
        "/api/accommodations/${widget.accomodation!.id}");
    setState(() {
      _accomodations = updatedData;

      print(updatedData.id);
      isLoading = false;
    });
    return updatedData;
  }

  final storage = const FlutterSecureStorage();
  late Accommodations _accomodation;
  ImageProvider? image;
  Future<String?> getAccessToken() async {
    final token = await storage.read(key: 'access_token');
    return token;
  }

  @override
  void initState() {
    super.initState();

    // getAccessToken();
    _accomodation = widget.accomodation!;
    _loadData();
    print('tokensss ${widget.token.toString()}');
  
  }

  

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _refresh() async {
    print("Screen refreshed");
    setState(() {
      _accomodation = Accommodations(
        id: _accomodation.id,
        hotelId:  _accomodation.hotel!.name,
        // update other properties as needed
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screen refreshed')),
    );
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("accomodation Detail"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :  

SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(_accomodations.note ?? ''),
                      Text(
                        "price : ${_accomodations.price ?? "Not yeat"}" ,
                            
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 15, 15),
                            fontWeight: FontWeight.w900,
                            fontSize: 24),
                      ),
                      Text(
                        " ${_accomodations.currency ?? "No currency"} ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 15, 15),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Adrres : ${_accomodations.hotel?.address ?? "No Address"}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 15, 15),
                            fontWeight: FontWeight.w900,
                            fontSize: 24),
                      ),
                      
                      Column(
                        children: [
                          Row(
                            children: List.generate(
                              _accomodations.hotel?.starsCount ?? 5,
                              (index) => Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 0, 15, 15),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 0, 15, 15),
                              ),
                              Text(
                                "Start number : ${_accomodations.hotel?.starsCount.toString()??"5"}" 
                                    ,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 15, 15),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                     
                  Text(
                    'Adult Number: ${_accomodations?.adultCount ??5} ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'roomNumber : ${_accomodations?.roomNumber??'no rom selected'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'childCount: ${_accomodations?.childCount ?? "Max 5"}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                 
                ],
              ),
            ),
        
    );
  }
}
