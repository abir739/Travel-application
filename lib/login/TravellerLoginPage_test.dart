import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
// import '../Secreens/Clientcalendar/client_calendar.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/tourist_calendar.dart';
import '../constent.dart';
import '../modele/traveller/TravellerModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class TravellerLoginPage extends StatefulWidget {
  const TravellerLoginPage({super.key});

  @override
  _TravellerLoginPageState createState() => _TravellerLoginPageState();
}

class _TravellerLoginPageState extends State<TravellerLoginPage> {
  final TextEditingController codeController = TextEditingController();
  List<Traveller> travellers = [];
  String errorMessage = '';

  Future<void> fetchTravellersByCode(String code) async {
    final url =
        Uri.parse('$baseUrls/api/travellers-mobile?filters[code]=$code');

    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List r = responseData["results"];
        final List<Traveller> fetchedTravellers =
            r.map((data) => Traveller.fromJson(data)).toList();

        setState(() {
          travellers = fetchedTravellers;
          errorMessage = ''; // Clear error message if successful
        });
      } else {
        setState(() {
          errorMessage =
              'Error fetching travellers. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
      });
    }
  }

  void _navigateToCalendarPage(Traveller selectedTraveller) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CalendarPage(selectedTraveller: selectedTraveller),
      ),
    );
  }

  void _handleSearchButton() {
    String code = codeController.text;
    if (code.isNotEmpty) {
      fetchTravellersByCode(code);
    } else {
      // Show the AlertDialog for empty code
      _showInvalidCodeDialog();
    }
  }

  void _showInvalidCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Code'),
          content:
              Text('Please verify the code or enter another correct code.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(width: 40),
            const Text(
              "Traveller Login",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              decoration:
                  const InputDecoration(labelText: 'Enter Traveller Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 5, 150),
              ),
              onPressed: _handleSearchButton, // Use the new method
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (travellers.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: travellers.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(travellers[index].title ?? ''),
                        subtitle: Text(
                          '${travellers[index].id ?? ''}, ${travellers[index].user?.email ?? ''}',
                        ),
                        onTap: () {
                          _navigateToCalendarPage(travellers[index]);
                          try {
                            OneSignal.shared.setAppId(
                                'ce7f9114-b051-4672-a9c5-0eec08d625e8');
                            OneSignal.shared.setSubscriptionObserver(
                                (OSSubscriptionStateChanges changes) {
                              print(
                                  "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
                            });
                            OneSignal.shared
                                .promptUserForPushNotificationPermission();
                            OneSignal.shared.sendTags({
                              'Groupids': '${travellers[index].touristGroupId}'
                            }).then((success) {
                              print("Tags created successfully");
                              Navigator.of(context).pop();
                              _navigateToCalendarPage(travellers[index]);
                              setState(() {
                                // Set loading state to true
                              });
                            }).catchError((error) {
                              print("Error creating tags: $error");
                            });
                          } catch (e) {
                            print('Error initializing OneSignal: $e');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
