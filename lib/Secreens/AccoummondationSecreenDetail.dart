import 'package:flutter/material.dart';

import '../modele/accommodationsModel/accommodationModel.dart';


class AccoumondationDetail extends StatelessWidget {
  Accommodations? accoumondation;
  AccoumondationDetail({this.accoumondation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('accoumondation Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adult Number: ${accoumondation!.adultCount} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'roomNumber : ${accoumondation!.roomNumber}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'childCount: ${accoumondation!.childCount}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Text(
            //   'Bus Color: ${accoumondation!.bus!.color}',
            //   style: TextStyle(fontSize: 18),
            // ),
            // SizedBox(height: 16),
            // Text(
            //   'Driver Phone: ${accoumondation!.driver!.phone}',
            //   style: TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Driver Name: ${accoumondation!.driver!.name}',
            //   style: TextStyle(fontSize: 18),
            // ),
            // Text(
            //   'Driver Licence Number: ${accoumondation!.driver!.licenceNumber}',
            //   style: TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}
