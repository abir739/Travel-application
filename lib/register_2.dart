import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zenify_trip/traveller_Screens/Clientcalendar/TravellerCalender.dart';


import 'constent.dart';
import 'modele/traveller/TravellerModel.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController codeController = TextEditingController();
  List<Traveller> travellers = [];
  String errorMessage = '';
  bool isLoading=false;
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         // CalendarPage(selectedTraveller: selectedTraveller),
    //   ),
    // );
    Get.to(TravellerCalendarPage(
      group: selectedTraveller.touristGroupId,
      tarveller: selectedTraveller,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your existing widgets go here
                TextField(
                  controller: codeController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Traveller Code'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, 'login');
                    Get.offNamed('login');
                  },
                  child: Text(
                    'Connect with Email && Password  ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
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
                              setState(() {
                                isLoading = true; // Set loading state to true
                              });
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent dismissing by tapping outside
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Loading...'),
                                      ],
                                    ),
                                  );
                                },
                              );
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
                                  'Groupids':
                                      '${travellers[index].touristGroupId}'
                                }).then((success) {
                                  print("Tags created successfully");
                                  Navigator.of(context).pop();
                                  _navigateToCalendarPage(travellers[index]);
                                  setState(() {
                                    isLoading =
                                        false; // Set loading state to true
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
          )

// Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.only(left: 35, top: 30),
//               child: Text(
//                 'Welcome Back',
//                 style: TextStyle(color: Colors.white, fontSize: 33),
//               ),
//             ),
//             SingleChildScrollView(
//               child:

// //  Container(
// //                 padding: EdgeInsets.only(
// //                     top: MediaQuery.of(context).size.height * 0.28),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       margin: EdgeInsets.only(left: 35, right: 35),
// //                       child: Column(
// //                         children: [
// //                           TextField(
// //                             style: TextStyle(color: Colors.white),
// //                             decoration: InputDecoration(
// //                                 enabledBorder: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                   borderSide: BorderSide(
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                                 focusedBorder: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                   borderSide: BorderSide(
// //                                     color: Colors.black,
// //                                   ),
// //                                 ),
// //                                 hintText: "ENte Your Code ex SV-....",
// //                                 hintStyle: TextStyle(color: Colors.white),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 )),
// //                           ),
// //                           // SizedBox(
// //                           //   height: 30,
// //                           // ),
// //                           // TextField(
// //                           //   style: TextStyle(color: Colors.white),
// //                           //   decoration: InputDecoration(
// //                           //       enabledBorder: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //         borderSide: BorderSide(
// //                           //           color: Colors.white,
// //                           //         ),
// //                           //       ),
// //                           //       focusedBorder: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //         borderSide: BorderSide(
// //                           //           color: Colors.black,
// //                           //         ),
// //                           //       ),
// //                           //       hintText: "Email",
// //                           //       hintStyle: TextStyle(color: Colors.white),
// //                           //       border: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //       )),
// //                           // ),
// //                           // SizedBox(
// //                           //   height: 30,
// //                           // ),
// //                           // TextField(
// //                           //   style: TextStyle(color: Colors.white),
// //                           //   obscureText: true,
// //                           //   decoration: InputDecoration(
// //                           //       enabledBorder: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //         borderSide: BorderSide(
// //                           //           color: Colors.white,
// //                           //         ),
// //                           //       ),
// //                           //       focusedBorder: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //         borderSide: BorderSide(
// //                           //           color: Colors.black,
// //                           //         ),
// //                           //       ),
// //                           //       hintText: "Password",
// //                           //       hintStyle: TextStyle(color: Colors.white),
// //                           //       border: OutlineInputBorder(
// //                           //         borderRadius: BorderRadius.circular(10),
// //                           //       )),
// //                           // ),
// //                           SizedBox(
// //                             height: 40,
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'VIsit',
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 27,
// //                                     fontWeight: FontWeight.w700),
// //                               ),
// //                               CircleAvatar(
// //                                 radius: 30,
// //                                 backgroundColor: Color(0xff4c505b),
// //                                 child: IconButton(
// //                                     color: Colors.white,
// //                                     onPressed: () {},
// //                                     icon: Icon(
// //                                       Icons.arrow_forward,
// //                                     )),
// //                               )
// //                             ],
// //                           ),
// //                           SizedBox(
// //                             height: 40,
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               TextButton(
// //                                 onPressed: () {
// //                                   // Navigator.pushNamed(context, 'login');
// //                                   Get.toNamed('login');
// //                                 },
// //                                 child: Text(
// //                                   'Connect as Guide ',
// //                                   textAlign: TextAlign.left,
// //                                   style: TextStyle(
// //                                       decoration: TextDecoration.underline,
// //                                       color: Colors.white,
// //                                       fontSize: 18),
// //                                 ),
// //                                 style: ButtonStyle(),
// //                               ),
// //                             ],
// //                           ),

// //                         ],
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),

//   ),
//           ],
//         ),

          ),
    );
  }
}
