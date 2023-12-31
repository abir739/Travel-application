import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:zenify_trip/guide_Screens/Guide_First_Page.dart';


import 'package:zenify_trip/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_trip/modele/agance.dart';

import '../constent.dart';
import '../modele/HttpActivityTemp.dart';
import '../modele/HttpAgancy.dart';
import '../modele/HttpPlaning.dart';
import '../modele/TouristGuide.dart';
import '../modele/activitsmodel/httpToristGroup.dart';
import '../modele/activitsmodel/httpToristguid.dart';
import '../modele/planningmainModel.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

import '../modele/touristGroup.dart';

class AddPlanningScreen extends StatefulWidget {
  const AddPlanningScreen({super.key});

  @override
  _AddPlanningScreenState createState() => _AddPlanningScreenState();
}

class _AddPlanningScreenState extends State<AddPlanningScreen> {
  final _formKey = GlobalKey<FormState>();
// create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  final String _agencyId = '822fe532-6138-43ea-8f61-9ce209247029';
  final String _activityTemplateId = 'a901463c-b73c-4267-b839-fa9a8d1a621a';
  final String _logo =
      '277771965_712318766460223_6468090819953743613_ndf0761ff-f8fc-4296-8c75-1a613d18703f.jpg';
  final String _touristGuideId = 'd771dd42-7c3b-42bb-95b7-fcb64c899f4d';
  String planningId = '996a8585-31d2-4174-911e-d0bb93b2a3f9';
  String _description = '';
  final String _reference = '';
  final String _departureDate = '';
  final String _departureNote = '';
  final String _returnDate = '';
  final String _returnNote = '';
  String _name = '';
  String _primaryColor = "";
  final bool _confirmed = true;
  final double _adultPrice = 0.0;
  final double _childPrice = 0.0;
  final double _babyPrice = 0.0;
  final int _placesCount = 0;
  DateTime _selectedDateTime = DateTime.now();
  DateTime _selectedDepartureDate = DateTime.now();
  final storage = const FlutterSecureStorage();
  final httpHandlerPlanning = HTTPHandlerplaning();
  final httpHandlerAgancy = HTTPHandlerAgancy();
  PlanningMainModel? selectedPlanning = PlanningMainModel();
  ActivityTemplate? selectedActivitytemp = ActivityTemplate();
  List<PlanningMainModel>? planning;
  List<ActivityTemplate>? activitestemp;
  Agency? selectedAgancy = Agency();
  List<Agency>? agancy;
  String token = "";
  bool circular = false;
  String filePath = '';
  final httpHandler = HTTPHandlerhttpToristguid();
  TouristGuide? selectedTouristGuide = TouristGuide();
  final httpHandleractivitytemp = HTTPHandleractivitytemp();
  List<TouristGuide>? touristGuides;
  final httpHandlertorist = HTTPHandlerhttpGroup();
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  ImageProvider? image;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadDataplanning();
    _loadDatagroup();
    _loadDataAgancy();
    _loadData();
    _loadDatactivitestemp();
    pickerColor = const Color(0xff443a49);
    _primaryColor = pickerColor.value.toRadixString(16).substring(2, 8);
  }

  void _loadDatagroup() async {
    setState(() {
      touristGroup = []; // initialize the list to an empty list
    });
    final data = await httpHandlertorist.fetchData("/api/tourist-groups");

    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first;
      isLoading = false;
    });
  }

  void _loadDataplanning() async {
    setState(() {
      planning = []; // initialize the list to an empty list
    });
    final data = await httpHandlerPlanning.fetchData("/api/plannings");
    setState(() {
      planning = data.cast<PlanningMainModel>();
      selectedPlanning = data.first;
      isLoading = false;
    });
  }

  void _loadDatactivitestemp() async {
    setState(() {
      activitestemp = []; // initialize the list to an empty list
    });
    final data =
        await httpHandleractivitytemp.fetchData("/api/activity-templates");
    setState(() {
      activitestemp = data.cast<ActivityTemplate>();
      selectedActivitytemp = data.first;
      isLoading = false;
    });
  }

  void _loadDataAgancy() async {
    setState(() {
      agancy = []; // initialize the list to an empty list
    });
    final data = await httpHandlerAgancy.fetchData("/api/agencies");
    setState(() {
      agancy = data.cast<Agency>();
      selectedAgancy = data.first;
      isLoading = false;
    });
  }

  void _loadData() async {
    setState(() {
      touristGuides = []; // initialize the list to an empty list
    });
    final data = await httpHandler.fetchData("/api/tourist-guides");
    setState(() {
      touristGuides = data.cast<TouristGuide>();
      selectedTouristGuide = data.first;
      isLoading = false;
    });
  }

  Future<void> _selectDepartureDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDepartureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDepartureDate),
      );
      if (time != null) {
        setState(() {
          _selectedDepartureDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            // time.hour,
            // time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            // pickedTime.hour,
            // pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> uploadFile(File file) async {
    // Get the access token
    String? token = await storage.read(key: "access_token");

    // Create the multipart request
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://192.168.1.23:3000/api/activities/upload/68ea8686-2ac7-4465-a986-aecfb643d372'));

    // Set the authorization header
    request.headers.addAll({'Authorization': 'Bearer $token'});

    // Add the file to the request
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode == 200) {
      print('File uploaded successfully!');
    } else {
      print('Error uploading file: ${response.statusCode}');
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (PlatformFile file in result.files) {
        print('File picked: ${file.name}');
        String filePath = file.path!;
        setState(() {
          image = FileImage(File(filePath));
        });
        await uploadFile(File(filePath));
      }
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }

  Future<void> _submitForm() async {
    String url;
    try {
      token = (await storage.read(key: "access_token"))!;
      String? baseUrl = await storage.read(key: "baseurl");

      final response = await http.post(
        Uri.parse('$baseUrls/api/plannings/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'agencyId': selectedAgancy!.id,

          'touristGroupId': selectedTouristGroup!.id,
          'startDate': _selectedDepartureDate
              .add(const Duration(hours: 1))
              .toIso8601String(),
          // 'departureNote': _departureNote,
          'endDate':
              _selectedDateTime.add(const Duration(hours: 1)).toIso8601String(),
          // 'returnNote': _returnNote,
          'enabled': true,
          'description': _description,
          // 'childPrice': _childPrice,
          // 'babyPrice': _babyPrice,
          // 'placesCount': _placesCount,
          // 'reference': _reference,
          // "planningId": selectedPlanning!.id,
          // "primaryColor": _primaryColor,
          "name": _name,
// 'currency':__description
        }),
      );

      if (response.statusCode == 201) {
        // Activity created successfully
        print('Activity created successfully!');
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Yap New planning created',
            message: '',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // Close the AddActivity page and navigate back to the previous page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlaningSecreen()),
        );
        //  Navigator.pop(context,'r');
        // Get.to(PlaningSecreen());
      } else {
        // Error creating activity
        print('Error creating activity: ${response.statusCode}');
      }
    } catch (error) {
      print('API error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(
                width: 28), // Add some spacing between text and SvgPicture
            const Text('Create New PLanning'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              DropdownButton<TouristGroup>(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                dropdownColor: const Color.fromARGB(244, 142, 172, 189),
                iconEnabledColor: const Color.fromARGB(161, 0, 0, 0),
                iconDisabledColor: const Color.fromARGB(255, 217, 5, 5),
                value: selectedTouristGroup,
                items: touristGroup!.map((touristGroup) {
                  return DropdownMenuItem<TouristGroup>(
                    value: touristGroup,
                    child: Text(
                        touristGroup.name ?? 'i know name for tourist guid'),
                  );
                }).toList(),
                onChanged: (TouristGroup? newValue) {
                  selectedTouristGroup = newValue!;
                },
              ),
              const SizedBox(height: 32),
              // DropdownButton<Agency>(
              //   value: selectedAgancy,
              //   items: agancy!.map((p) {
              //     return DropdownMenuItem<Agency>(
              //       value: p,
              //       child: Text(p.name ?? 'h'),
              //     );
              //   }).toList(),
              //   onChanged: (Agency? newValue) {
              //     setState(() {
              //       selectedAgancy = newValue!;
              //       print(selectedAgancy!.id);
              //     });
              //   },
              //   style: const TextStyle(
              //     color: Color.fromARGB(255, 3, 1, 12),
              //     fontSize: 16.0,
              //   ),
              //   borderRadius: const BorderRadius.all(Radius.circular(20)),
              //   dropdownColor: const Color.fromARGB(255, 210, 151, 3),
              //   iconEnabledColor: const Color.fromARGB(161, 0, 0, 0),
              //   iconDisabledColor: const Color.fromARGB(255, 158, 158, 158),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: const Text('Pick a color!'),
              //           content: SingleChildScrollView(
              //             child: ColorPicker(
              //               pickerColor: pickerColor,
              //               onColorChanged: changeColor,
              //             ),
              //           ),
              //           actions: <Widget>[
              //             ElevatedButton(
              //               child: const Text('Got it'),
              //               onPressed: () {
              //                 setState(
              //                   () => currentColor = pickerColor,
              //                 );
              //                 setState(() => _primaryColor =
              //                     '#${pickerColor.value.toRadixString(16).substring(2, 8)}');
              //                 Navigator.of(context).pop();
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: currentColor,
              //   ),
              //   child: const Text('Select color'),
              // ),
              // const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Planning Description',
                  hintText: 'Planning Description',
                  prefixIcon: const Icon(Icons.pending_actions),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // decoration: InputDecoration(labelText: 'Plannig description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Planning description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Planning Name',
                  hintText: 'Planning Name',
                  prefixIcon: const Icon(Icons.pages),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // decoration: InputDecoration(labelText: 'Planning Name'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Planning Name';
                  }
                  // You can add more validation logic if needed
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                // decoration: InputDecoration(labelText: 'Departure Date'),
                decoration: InputDecoration(
                  labelText: 'Depart Date',
                  prefixIcon: const Icon(Icons.date_range),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: _selectDepartureDate,
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd')
                        .format(_selectedDepartureDate)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Return Date',
                  prefixIcon: const Icon(Icons.date_range),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => _selectDateTime(context),
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_selectedDateTime),
                ),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                width: Get.width * 0.2,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFEB5F52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                    // }
                  },
                  child: const Center(
                    child: Text(
                      'Create planning',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
