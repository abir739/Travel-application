import 'package:flutter/material.dart';
import 'package:zenify_trip/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';
// Import the User model

class ProfilePage extends StatelessWidget {
  final Traveller selectedTraveller;

  ProfilePage({required this.selectedTraveller});

  @override
  Widget build(BuildContext context) {
    User? user = selectedTraveller.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(user?.picture ?? ''),
              ),
            ),
            // Traveler Information (with null checks)
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                  'Name: ${user?.firstName ?? ''} ${user?.lastName ?? ''}'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email: ${user?.email ?? ''}'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone: ${user?.phone ?? ''}'),
            ),
            // Add more traveler information as needed with null checks
          ],
        ),
      ),
    );
  }
}
