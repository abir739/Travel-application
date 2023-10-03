import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/guide_Screens/Guide_First_Page.dart';

import 'package:zenify_trip/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_trip/modele/agance.dart';

import '../constent.dart';
import '../modele/HttpActivityTemp.dart';
import '../modele/HttpAgancy.dart';
import '../modele/HttpPlaning.dart';
import '../modele/TouristGuide.dart';
import '../modele/activitsmodel/httpToristguid.dart';
import '../modele/planningmainModel.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';





class AddTouristGuideScreen extends StatefulWidget {
  const AddTouristGuideScreen({super.key});

  @override
  _AddTouristGuideScreenState createState() => _AddTouristGuideScreenState();
}

class _AddTouristGuideScreenState extends State<AddTouristGuideScreen> {
  final _formKey = GlobalKey<FormState>();
// create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // String? touristGroupId;
  // String? name;
  // DateTime? startDate;
  // DateTime? endDate;
  // String? description;
  // bool? enabled;
  // String? creatorUserId;
  // String? createdAt;
  // String? updaterUserId;
  // String? updatedAt;
  // DateTime? deletedAt;
  // Agency? agency;
// String touristGuideId='';
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
  ImageProvider? image;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // _loadDataplanning();
    _loadDataAgancy();
    // _loadData();
    // _loadDatactivitestemp();
    pickerColor = const Color(0xff443a49);
    _primaryColor = pickerColor.value.toRadixString(16).substring(2, 8);
  }
  // Future<void> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     print('File picked: ${file.name}');
  //     String imagePath = file.path!;
  //     setState(() {
  //       image = FileImage(File(imagePath));
  //     });
  //   } else {
  //     // User canceled the picker
  //     print('User canceled the picker');
  //   }
  // }
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
            time.hour,
            time.minute,
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
            pickedTime.hour,
            pickedTime.minute,
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

  // Future<void> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     print('File picked: ${file.name}');
  //     String filePath = file.path!;
  //     setState(() {
  //       image = FileImage(File(filePath));
  //     });
  //     await uploadFile(File(filePath));
  //   } else {
  //     // User canceled the picker
  //     print('User canceled the picker');
  //   }
  // }
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
        Uri.parse('$baseUrls/api/tourist-guides/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'agencyId': selectedAgancy!.id,
          
          // 'logo':
          //     '277771965_712318766460223_6468090819953743613_ndf0761ff-f8fc-4296-8c75-1a613d18703f.jpg',
          
       
          // 'departureNote': _departureNote,
      
          // 'returnNote': _returnNote,
       
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
            title: 'Yap Activity   success',
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
          MaterialPageRoute(
              builder: (context) => const PlaningSecreen(
          )),
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

  // Future<void> createActivity(newActivity) async {
  //   try {
  //     token = await storage.read(key: "access_token");
  //     final url = 'http://localhost:3000/api/activities/';

  //     final headers = {
  //       'accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     };

  //     final body = jsonEncode({
  //       'agencyId': newActivity.agencyId,
  //       'activityTemplateId': newActivity.activityTemplateId,
  //       'logo': newActivity.logo,
  //       'touristGuideId': newActivity.touristGuideId,
  //       'departureDate': newActivity.departureDate.toIso8601String(),
  //       'departureNote': newActivity.departureNote,
  //       'returnDate': newActivity.returnDate.toIso8601String(),
  //       'returnNote': newActivity.returnNote,
  //       'confirmed': newActivity.confirmed,
  //       'adultPrice': newActivity.adultPrice,
  //       'childPrice': newActivity.childPrice,
  //       'babyPrice': newActivity.babyPrice,
  //       'placesCount': newActivity.placesCount,

  //     });

  //     final response =
  //         await http.post(Uri.parse(url), headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       // Activity created successfully
  //       print('Activity created successfully!');
  //     } else {
  //       // Error creating activity
  //       print('Error creating activity: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('API error: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    return Scaffold(
      appBar: AppBar(
    automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(210, 55, 4, 221),
                  Color.fromARGB(255, 189, 4, 4)
                ],
              ),
            ),
          ),
        title: const Text('create new touristgroup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
child: Column(
            children: [
  // DropdownButton<TouristGuide>(
  //               value: selectedTouristGuide,
  //               items: touristGuides!.map((touristGuide) {
  //                 return DropdownMenuItem<TouristGuide>(
  //                   value: touristGuide,
  //                   child: Text(touristGuide.name ?? 'h'),
  //                 );
  //               }).toList(),
  //               onChanged: (TouristGuide? newValue) {
  //                 setState(() {
  //                   selectedTouristGuide = newValue!;
  //                   // _loadDataplanning();
  //                   print(selectedTouristGuide!.id);
  //                 });
  //               },
  //             ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Agency ID'),
              //   onChanged: (value) {
              //     setState(() {
              //       _agencyId = value;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Activity Template ID'),
              //   onChanged: (value) {
              //     setState(() {
              //       _activityTemplateId = value;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Tourist Guide ID'),
              //   onChanged: (value) {
              //     setState(() {
              //       _touristGuideId = value;
              //     });
              //   },
              // ),
              const SizedBox(height: 32),
              Container(
                child: Column(
                  mainAxisAlignment : MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     DropdownButton<PlanningMainModel>(
                    //       borderRadius: BorderRadius.circular(8),   dropdownColor: Color.fromARGB(255, 240, 228, 228).withOpacity(0.8),
                    //       value: selectedPlanning,
                    //       items: planning!.map((p) {
                    //         return DropdownMenuItem<PlanningMainModel>(
                    //           value: p,
                    //           child: Text(p.name ?? 'h'),
                    //         );
                    //       }).toList(),
                    //       onChanged: (PlanningMainModel? newValue) {
                    //         setState(() {
                    //           selectedPlanning = newValue!;
                    //           print(selectedPlanning!.id);
                    //         });
                    //       },
                    //       style: TextStyle(
                    //         color: Color.fromARGB(255, 4, 0, 14),
                    //         fontSize: 16.0,
                    //       ),
                    //     elevation: 0, alignment :AlignmentDirectional.center,
                    //       iconEnabledColor: Colors.black,
                    //       iconDisabledColor: Color.fromARGB(255, 158, 158, 158),
                    //     ),
                    //     const SizedBox(width: 32),
                    //     DropdownButton<ActivityTemplate>(
                    //       value: selectedActivitytemp,
                    //       items: activitestemp!.map((p) {
                    //         return DropdownMenuItem<ActivityTemplate>(
                    //           value: p,
                    //           child: Text(p.name ?? 'h'),
                    //         );
                    //       }).toList(),
                    //       onChanged: (ActivityTemplate? newValue) {
                    //         setState(() {
                    //           selectedActivitytemp = newValue!;
                    //           print(selectedActivitytemp!.id);
                    //         });
                    //       },
                    //       style: TextStyle(
                    //         color: Color.fromARGB(255, 52, 3, 201),
                    //         fontSize: 16.0,
                    //       ),
                    //       dropdownColor: Colors.white,
                    //       iconEnabledColor: Colors.black,
                    //       iconDisabledColor: Color.fromARGB(255, 158, 158, 158),
                    //     ),
                    //   ],
                    // ),
                   
                    const SizedBox(width: 32),
                    DropdownButton<Agency>(
                      value: selectedAgancy,
                      items: agancy!.map((p) {
                        return DropdownMenuItem<Agency>(
                          value: p,
                          child: Text(p.name ?? 'h'),
                        );
                      }).toList(),
                      onChanged: (Agency? newValue) {
                        setState(() {
                          selectedAgancy = newValue!;
                          print(selectedAgancy!.id);
                        });
                      },
                      style: const TextStyle(
                        color: Color.fromARGB(255, 52, 3, 201),
                        fontSize: 16.0,
                      ),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: const Color.fromARGB(255, 158, 158, 158),
                    ),
                  ],
                ),
              ),
//               Center(
//                 child: image != null
//                     ? Image(image: image!)
//                     : Text("text "),
//               ),
// ElevatedButton(
//                 onPressed: pickFile,
//                 child: Text('Select File'),
//               ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(
                                () => currentColor = pickerColor,
                              );
                              setState(() => _primaryColor =
                                  '#${pickerColor.value.toRadixString(16).substring(2, 8)}');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentColor,
                ),
                child: const Text('Select color'),
              ),

              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Reference'),
              //   onChanged: (value) {
              //     setState(() {
              //       _reference = value;
              //     });
              //   },
              // ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'description'),
                onChanged: (value) {
                  setState(() {
                _description = value;
                  });
                },
              ),
              const Text('Agancy List  :'),
              const SizedBox(width: 50),
              DropdownButton<Agency>(
                value: selectedAgancy,
                items: agancy!.map((p) {
                  return DropdownMenuItem<Agency>(
                    value: p,
                    child: Text(p.name ?? 'h'),
                  );
                }).toList(),
                onChanged: (Agency? newValue) {
                  setState(() {
                    selectedAgancy = newValue!;
                    print(selectedAgancy!.id);
                  });
                },
                style: const TextStyle(
                  color: Color.fromARGB(255, 52, 3, 201),
                  fontSize: 16.0,
                ),
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
                iconDisabledColor: const Color.fromARGB(255, 158, 158, 158),
              ),
 TextFormField(
                decoration: const InputDecoration(labelText: 'Activity Name'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Logo'),
              //   onChanged: (value) {
              //     setState(() {
              //       _logo = value;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Departure Date'),
              //   onChanged: (value) {
              //     setState(() {
              //       _departureDate = value;
              //     });
              //   },
              // // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Departure Date'),
              //   onTap: _selectDepartureDate,
              //   controller: TextEditingController(
              //       text: DateFormat('yyyy-MM-dd HH:mm')
              //           .format(_selectedDepartureDate)),
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Return Date'),
              //   onChanged: (value) {
              //     setState(() {
              //       _returnDate = value;
              //     });
              //   },
              // ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Return Date'),
//                 onTap: () => _selectDateTime(context),
//                 controller: TextEditingController(
//                   text:
//                       DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime),
// // DateFormat.yMMMMEEEEd()
// //                       .add_Hm()
// //                       .format(_selectedDateTime),
//                 ),
//               ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Return Note'),
              //   onChanged: (value) {
              //     setState(() {
              //       _returnNote = value;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Confirmed'),
              //   onChanged: (value) {
              //     setState(() {
              //       _confirmed = value as bool;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Adult Price'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     setState(() {
              //       _adultPrice = double.tryParse(value) ?? 0.0;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Child Price'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     setState(() {
              //       _childPrice = double.tryParse(value) ?? 0.0;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Baby Price'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     setState(() {
              //       _babyPrice = double.tryParse(value) ?? 0.0;
              //     });
              //   },
              // ),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Places Count'),
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     setState(() {
              //       _placesCount = int.tryParse(value) ?? 0;
              //     });
              //   },
              // ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  // // Save the form data into a newActivity object
                  // Map<String, dynamic> newActivity = {
                  //   'agencyId': '822fe532-6138-43ea-8f61-9ce209247029',
                  //   'activityTemplateId':
                  //       'a901463c-b73c-4267-b839-fa9a8d1a621a',
                  //   'logo': _logo,
                  //   'touristGuideId': 'd771dd42-7c3b-42bb-95b7-fcb64c899f4d',
                  //   'departureDate':_selectedDepartureDate ,
                  //   'departureNote': _departureNote,
                  //   'returnDate': _selectedDateTime,
                  //   'returnNote': _returnNote,
                  //   'confirmed': true,
                  //   'adultPrice': _adultPrice,
                  //   'childPrice': _childPrice,
                  //   'babyPrice': _babyPrice,
                  //   'placesCount': _placesCount,
                  //   'reference': _reference,
                  // };

                  // // Send the new activity data to the server
                  // createActivity(newActivity);
                  _submitForm();
                  // }
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
// }
