import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
// import '../Secreens/Clientcalendar/client_calendar.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/tourist_calendar.dart';
import '../constent.dart';
import '../modele/traveller/TravellerModel.dart';

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
                primary: const Color.fromARGB(255, 68, 5, 150),
              ),
              onPressed: () {
                String code = codeController.text;
                if (code.isNotEmpty) {
                  fetchTravellersByCode(code);
                }
              },
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
