import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/touristGroup.dart';
// ignore: depend_on_referenced_packages

import '../constent.dart';
import '../modele/TouristGuide.dart';
import '../modele/activitsmodel/httpActivites.dart';
import '../modele/activitsmodel/httpToristGroup.dart';
import '../modele/activitsmodel/httpToristguid.dart';
import 'AddTouristGuideScreen.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  TouristGuide? selectedTouristGuide = TouristGuide();
  final count = HTTPHandlerCount();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _androidAccentColorController =
      TextEditingController();
  final TextEditingController _bigPictureController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final httpHandler = HTTPHandlerhttpToristguid();
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? group;
  List<TouristGroup>? groupOptions = [];
  String token = "";
  String baseUrl = "";

  List<MultiSelectItem<TouristGroup>> multiSelectItems = [];
  void initializeMultiSelectItems() {
    if (groupOptions != null) {
      multiSelectItems = group!
          .map(
              (p) => MultiSelectItem<TouristGroup>(p, p.name ?? 'Default Name'))
          .toList();
      Tags = multiSelectItems.map((item) => item.value.id!).toList();
    }
  }

  List<String> Tags = [];

  Set<TouristGroup> selectedGroup = {};
  @override
  void initState() {
    super.initState();
    // initializeMultiSelectItems();
    _loadData();
    _loadDatagroup();
  }

  void _loadData() async {
    token = (await storage.read(key: "access_token"))!;

    baseUrl = (await storage.read(key: "baseurl"))!;
    setState(() {
      touristGuides = []; // initialize the list to an empty list
    });
    final data = await httpHandler.fetchData("/api/tourist-guides");

    if (data == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTouristGuideScreen()),
      );
      return; // Stop further execution of the function
    }
    setState(() {
      touristGuides = data.cast<TouristGuide>();
      selectedTouristGuide = data.first;
    });
    _loadDatagroup(); // Call _loadDatagroup after loading data
  }

  final httpHandlertorist = HTTPHandlerhttpGroup();
  String backendUrl = "";
  final storage = const FlutterSecureStorage();
  void _loadDatagroup() async {
    setState(() {
      touristGroup = [];
      group = []; // initialize the list to an empty list
      multiSelectItems = []; // initialize the list to an empty list
    });
    final data = await httpHandlertorist.fetchData(
        "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}");
    if (data == null) {
      // Data is null, navigate to the 'addtouristguid' screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTouristGuideScreen()),
      );
      return; // Stop further execution of the function
    }
    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first;
      group = touristGroup;
      initializeMultiSelectItems();
    });
  }

  Map<String, String> sendSelectedTags(
      List<MultiSelectItem<TouristGroup>> multiSelectItems) {
    Map<String, String> selectedTagsMap = {};
    for (var item in multiSelectItems) {
      if (item.selected) {
        String tagId = item.value.id!;
        selectedTagsMap['GroupName_Tag'] = tagId;
      }
    }
    return selectedTagsMap;
  }

  Future<void> sendNotification() async {
    String? backendUrl1 = await storage.read(key: "access_token");
    backendUrl = (await storage.read(key: "access_token"))!;

    if (backendUrl.isEmpty) {
      print('Error: Backend URL is not set');
      return;
    }

    try {
      Map<String, String> selectedTagsMap = sendSelectedTags(multiSelectItems);
      var response = await http.post(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json, text/plain, */*",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
          "Connection": "keep-alive",
        },
        Uri.parse('$baseUrls/api/push-notifications/notification'),
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        body: jsonEncode({
          'message': _messageController.text,
          'title': _titleController.text,
          'android_accent_color': _androidAccentColorController.text,
          'big_picture': _bigPictureController.text,
          'type': _linkUrlController.text,
          'tags': selectedTagsMap,
        }),
      );

      if (response.statusCode == 201) {
        // Notification sent successfully
        print('Notification sent successfully!');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: const Row(
          children: [
            // SvgPicture.asset(
            //   'assets/images/Logo.svg',
            //   fit: BoxFit.cover,
            //   height: 36.0,
            // ),
            // const SizedBox(width: 30),
            // const Text('Push Notification'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color.fromARGB(235, 79, 2, 2)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MultiSelectDialogField<TouristGroup>(
                items: multiSelectItems,
                isDismissible: false,
                initialValue: selectedGroup.toList(),
                dialogHeight: Get.height * 0.2,
                barrierColor: const Color.fromARGB(146, 129, 129, 129),
                title: const Text('group List'),
                separateSelectedItems: true,
                selectedColor: Colors.purple,
                searchable: true,
                selectedItemsTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 133, 3, 133),
                ),
                unselectedColor: const Color.fromARGB(255, 8, 88, 180),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one group';
                  }

                  return null;
                },
                onConfirm: (List<TouristGroup> values) {
                  setState(() {
                    selectedGroup = values.toSet();
                  });
                },
                chipDisplay: MultiSelectChipDisplay<TouristGroup>(),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //     color: Color.fromARGB(244, 188, 95, 3),
            //   ),
            //   alignment: Alignment.center,
            //   padding: EdgeInsets.all(5.0),
            //   margin: EdgeInsets.only(left: 60, right: 60),
            //   child: touristGroup!.isEmpty
            //       ? ElevatedButton(
            //           style: ButtonStyle(
            //             backgroundColor: MaterialStateProperty.all<Color>(
            //                 Color.fromARGB(184, 209, 17,
            //                     17)), // Set the desired background color
            //           ),
            //           onPressed: () {
            //             // Handle button press, navigate to desired screen or perform any action
            //             Get.to(AddTouristGroupScreen());
            //           },
            //           child: Text('you are not effect  group'),
            //         )
            //       : Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Container(
            //               width: 120, // Set the desired width
            //               height: 60,
            //               child: DropdownButton<TouristGroup>(
            //                 borderRadius: BorderRadius.all(Radius.circular(20)),
            //                 dropdownColor: Color.fromARGB(255, 210, 151, 3),
            //                 iconEnabledColor: Color.fromARGB(161, 0, 0, 0),
            //                 iconDisabledColor:
            //                     Color.fromARGB(255, 158, 158, 158),
            //                 value: selectedTouristGroup,
            //                 items: touristGroup!.map((touristGroup) {
            //                   return DropdownMenuItem<TouristGroup>(
            //                       value: touristGroup,
            //                       child: Row(
            //                         children: [
            //                           Icon(
            //                             Icons.group,
            //                             size:
            //                                 20, // Set the desired size of the icon
            //                           ),
            //                           SizedBox(
            //                               width:
            //                                   8), // Add some spacing between the icon and text
            //                           Text(
            //                             touristGroup.name ?? 'i known Group',
            //                             style: TextStyle(
            //                                 fontSize: 16,
            //                                 color:
            //                                     Color.fromARGB(255, 88, 19, 2)),
            //                           ),
            //                         ],
            //                       ));
            //                 }).toList(),
            //                 onChanged: (TouristGroup? newValue) {
            //                   setState(() {
            //                     // OneSignal.shared
            //                     //     .deleteTag('${selectedTouristGroup?.id}')
            //                     //     .then((success) {
            //                     //   print("Old tags deleted successfully");
            //                     // }).catchError((error) {
            //                     //   print("Error deleting old tags: $error");
            //                     // });

            //                     // selectedTouristGroup = newValue!;
            //                     // tag = newValue.id!;
            //                     // _loadDataplanning();
            //                     if (selectedTouristGroup?.id != null) {
            //                       // try {
            //                       //   OneSignal.shared.setAppId(
            //                       //       'a83993b3-1680-49fa-a371-c5ad4c55849a');
            //                       //   OneSignal.shared.setSubscriptionObserver(
            //                       //       (OSSubscriptionStateChanges changes) {
            //                       //     print(
            //                       //         "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
            //                       //   });
            //                       //   OneSignal.shared
            //                       //       .promptUserForPushNotificationPermission();
            //                       //   OneSignal.shared.sendTags({
            //                       //     '${selectedTouristGroup?.id}':
            //                       //         '${selectedTouristGroup?.id}'
            //                       //   }).then((success) {
            //                       //     print("Tags created successfully");
            //                       //   }).catchError((error) {
            //                       //     print("Error creating tags: $error");
            //                       //   });
            //                       // } catch (e) {
            //                       //   print('Error initializing OneSignal: $e');
            //                       // }
            //                     }
            //                     print(selectedTouristGroup!.id);
            //                   });
            //                 },
            //               ),
            //             ),
            //             ElevatedButton(
            //               style: ButtonStyle(
            //                 backgroundColor: MaterialStateProperty.all<Color>(
            //                     Color.fromARGB(184, 209, 17,
            //                         17)), // Set the desired background color
            //               ),
            //               onPressed: () {
            //                 // Handle button press, navigate to desired screen or perform any action
            //                 Get.to(AddTouristGroupScreen());
            //               },
            //               child: Text('new Goup'),
            //             ),
            //             FutureBuilder<int>(
            //               future: count.fetchInlineCount(
            //                 "/api/tourist-groups/touristGuideId/${selectedTouristGuide!.id}",
            //               ),
            //               builder: (context, snapshot) {
            //                 if (snapshot.connectionState ==
            //                     ConnectionState.waiting) {
            //                   // Display a loading indicator while fetching the inline count
            //                   return CircularProgressIndicator(
            //                       strokeWidth: 1.0);
            //                 }
            //                 if (snapshot.hasError) {
            //                   // Handle the error if the inline count couldn't be fetched
            //                   return Text("Error");
            //                 }
            //                 final inlineCount = snapshot.data ?? 0;
            //                 return Text(
            //                   " $inlineCount",
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.w800, fontSize: 20),
            //                 );
            //               },
            //             ),
            //           ],
            //         ),
            // ),
            // const SizedBox(height: 32),
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(47, 181, 89, 3),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: touristGuides!.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          // Handle button press, navigate to desired screen or perform any action
                          Get.to(const AddTouristGuideScreen());
                        },
                        child: const Text(
                            'you are not effect to any tourist guid'),
                      )
                    : SizedBox(
                        width: 800, // Set the desired width
                        height: 50, // Set the desired height
                        child: Row(
                          children: [
                            DropdownButton<TouristGuide>(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              dropdownColor:
                                  const Color.fromARGB(255, 229, 224, 224),
                              iconEnabledColor:
                                  const Color.fromARGB(160, 245, 241, 241),
                              iconDisabledColor:
                                  const Color.fromARGB(255, 158, 158, 158),
                              value: selectedTouristGuide,
                              items: touristGuides!.map((touristGuide) {
                                return DropdownMenuItem<TouristGuide>(
                                  value: touristGuide,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size:
                                            20, // Set the desired size of the icon
                                      ),
                                      const SizedBox(
                                          width:
                                              14), // Add some spacing between the icon and text
                                      Text(
                                        touristGuide.name ?? 'h',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 103, 1, 1)),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (TouristGuide? newValue) {
                                // setState(() {
                                //   OneSignal.shared
                                //       .deleteTag('${selectedTouristGuide?.id}')
                                //       .then((success) {
                                //     print("Old tags deleted successfully");
                                //   }).catchError((error) {
                                //     print("Error deleting old tags: $error");
                                //   });

                                selectedTouristGuide = newValue!;
                                // tag = newValue.id!;
                                // _loadDataplanning();
                                _loadDatagroup();
                                //   if (selectedTouristGuide?.id != null) {
                                //     try {
                                //       OneSignal.shared.setAppId(
                                //           'a83993b3-1680-49fa-a371-c5ad4c55849a');
                                //       OneSignal.shared.setSubscriptionObserver(
                                //           (OSSubscriptionStateChanges changes) {
                                //         print(
                                //             "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
                                //       });
                                //       OneSignal.shared
                                //           .promptUserForPushNotificationPermission();
                                //       OneSignal.shared.sendTags({
                                //         '${selectedTouristGuide?.id}':
                                //             '${selectedTouristGuide?.id}'
                                //       }).then((success) {
                                //         print("Tags created successfully");
                                //       }).catchError((error) {
                                //         print("Error creating tags: $error");
                                //       });
                                //     } catch (e) {
                                //       print('Error initializing OneSignal: $e');
                                //     }
                                //   }
                                //   print(selectedTouristGuide!.id);
                                // });
                              },
                            ),
                            // FutureBuilder<int>(
                            //   future: count.fetchInlineCount(
                            //     "/api/tourist-guides",
                            //   ),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       // Display a loading indicator while fetching the inline count
                            //       return CircularProgressIndicator(
                            //           strokeWidth: 1.0);
                            //     }
                            //     if (snapshot.hasError) {
                            //       // Handle the error if the inline count couldn't be fetched
                            //       return Text("Error");
                            //     }
                            //     final inlineCount = snapshot.data ?? 0;
                            //     return Text(
                            //       " $inlineCount",
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.w800,
                            //           fontSize: 20),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      )),

            const SizedBox(height: 50),
            TextFormField(
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 6, 70, 189),
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                )),
                labelText: "Message",
                helperText: "Write about  Notification",
                hintText: "Notification Message",
              ),
              controller: _messageController,
              // decoration: InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            // TextField(
            //   controller: _androidAccentColorController,
            //   decoration: InputDecoration(labelText: 'Android Accent Color'),
            // ),
            // TextField(
            //   controller: _bigPictureController,
            //   decoration: InputDecoration(labelText: 'Big Picture'),
            // ),
            // TextField(
            //   controller: _linkUrlController,
            //   decoration: InputDecoration(labelText: 'Type/Link URL'),
            // ),

            const SizedBox(height: 26),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(244, 78, 3, 73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Send Notification'),
              onPressed: () {
                sendNotification();
              },
            ),
          ],
        ),
      ),
    );
  }
}
