import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../constent.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/httpToristGroup.dart';
import '../../modele/activitsmodel/httpToristguid.dart';
import '../../modele/planningmainModel.dart';
import '../../modele/touristGroup.dart';
import 'package:flutter_svg/svg.dart';

class PushNotificationScreen extends StatefulWidget {
  TouristGuide? guid;
  PushNotificationScreen(this.guid, {super.key});

  @override
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  TouristGuide? selectedTouristGuide = TouristGuide();
  TouristGroup? SelectedTouristGroup = TouristGroup();
  final count = HTTPHandlerCount();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bigPictureController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();
  final httpHandler = HTTPHandlerhttpToristguid();
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? group;
   List<TouristGroup>? touristGroups;
  List<TouristGroup>? groupOptions = [];
  String token = "";
  String baseUrl = "";
  get selectedPlanning => PlanningMainModel();

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

  // ignore: non_constant_identifier_names
  List<String> Tags = [];

  Set<TouristGroup> selectedGroup = {};
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    setState(() {
      touristGuides = []; // initialize the list to an empty list
    });
    final data = await httpHandler.fetchData("/api/tourist-guides");

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
    final data = await httpHandlertorist
        .fetchData("/api/tourist-groups/touristGuideId/${widget.guid!.id}");

    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first;
      group = touristGroup;
      initializeMultiSelectItems();
    });
  }

  Map<String, List<String>> selectedTagsMapsendSelectedTags(
    List<MultiSelectItem<TouristGroup>> multiSelectItems,
  ) {
    Map<String, List<String>> selectedTagsMap = {
      "Groupids": [],
    };

    for (var item in multiSelectItems) {
      if (item.selected) {
        String tagId = item.value.id!;
        selectedTagsMap["Groupids"]!.add(tagId);
      }
    }

    return selectedTagsMap; // Always return the map
  }

  Future<void> sendNotification() async {
    try {
      Map<String, List<String>> selectedTagsMap =
          selectedTagsMapsendSelectedTags(multiSelectItems);
      var response = await http.post(
        Uri.parse('$baseUrls/api/push-notificationsMobile/notification'),
        headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImUxMWU0N2FhLTE5YzgtNDM5Mi1hMGEyLTkwN2NmYTg0MzM4OCIsInN1YiI6ImUxMWU0N2FhLTE5YzgtNDM5Mi1hMGEyLTkwN2NmYTg0MzM4OCIsInVzZXJuYW1lIjoic2E3Ym9vY2gzIiwiZW1haWwiOiJzYTdib29jaDNAZ21haWwuY29tIiwicm9sZSI6IkFkbWluaXN0cmF0b3IiLCJmaXJzdE5hbWUiOiJTYWhiaSIsImxhc3ROYW1lIjoiS2hhbGZhbGxhaCIsImV4cGlyZXMiOjE2OTQ2MTAyNTksImNyZWF0ZWQiOjE2OTQ1MjM4NTksImlhdCI6MTY5NDUyMzg1OSwiZXhwIjoxNjk0NjEwMjU5fQ.x_DdGrIykF7AQIUoSLkNlSXUuQWB_8Ev_1cVg2OEP1A",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "message": _messageController.text, // Use the entered message
          "title": _titleController.text, // Use the entered title
          "type": _linkUrlController.text.isNotEmpty
              ? _linkUrlController.text
              : _bigPictureController
                  .text, // Use either link URL or picture URL
          "tags": selectedTagsMap,
          "mutable_content": false,
          "android_sound": null,
          "small_icon": null,
          "large_icon": null,
          "big_picture":
              "https://www.destinationtunisie.info/wp-content/uploads/2019/05/hotel_barcelo_sousse_-marhaba.jpg",
          "android_led_color": "ed0000",
          "android_accent_color": "ed0000",
          "android_group": null,
          "android_visibility": 0,
          "app_id": "****"
        }),
      );

      if (response.statusCode == 201) {
        // Notification sent successfully
        print('Selected Tags Map: $selectedTagsMap');
        print('Notification sent successfully!');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Selected Tags Map: $selectedTagsMap');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  
void _loadDataGroups() async {
    setState(() {
      touristGroups = []; // initialize the list to an empty list
    });
    final data = await httpHandler.fetchData("/api/tourist-groups");

    setState(() {
      touristGroups = data.cast<TouristGroup>();
      SelectedTouristGroup = data.first as TouristGroup?;
    });
    _loadDatagroup(); // Call _loadDatagroup after loading data
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
            const SizedBox(width: 30),
            const Text(
              'Push notification',
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 24,
              ),
            ),
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
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(47, 181, 89, 3),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2.0),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: touristGuides!.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          // Handle button press, navigate to desired screen or perform any action
                          // Get.to(AddTouristGuideScreen());
                        },
                        child: const Text(
                            'you are not effect to any tourist guid'),
                      )
                    : SizedBox(
                        width: 800, // Set the desired width
                        height: 60, // Set the desired height
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
                                              8), // Add some spacing between the icon and text
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
                                selectedTouristGuide = newValue!;

                                _loadDatagroup();
                              },
                            ),
                          ],
                        ),
                      )),
            const SizedBox(height: 32),
            // TextFields for title, message, picture URL, and link URL
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _messageController, // Add this line
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            TextField(
              controller: _bigPictureController,
              decoration: const InputDecoration(labelText: 'Big Picture URL'),
            ),
            TextField(
              controller: _linkUrlController,
              decoration: const InputDecoration(labelText: 'Link URL'),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFEB5F52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                sendNotification();
              },
              child: const Center(
                child: Text(
                  'Send Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
