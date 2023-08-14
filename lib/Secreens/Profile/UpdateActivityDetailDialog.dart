// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:zenify_trip_mobile/modele/activitsmodel/activitesmodel.dart';
// import '../../NetworkHandler.dart';
// import '../../modele/HttpUserHandler.dart';
// import '../../modele/activitsmodel/usersmodel.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class UpdateActivityDetailDialog extends StatefulWidget {
//   final String field;
//   final String initialValue;
//   final Activity activity;
//   String? baseUrl;
//   final Function(String, String) onUpdateDetail;
//   UpdateActivityDetailDialog({
//     required this.field,
//     required this.initialValue,
//     required this.activity,
//     required this.onUpdateDetail,
//     this.baseUrl,
//   });

//   @override
//   _UpdateActivityDetailDialogState createState() =>
//       _UpdateActivityDetailDialogState();
// }

// class _UpdateActivityDetailDialogState
//     extends State<UpdateActivityDetailDialog> {
//   String baseUrl = "";
//   String updatedValue = '';
//   int selectedIndex = -1;
//   bool circular = true;
//   Color pickerColor = Color(0xff443a49);
//   Color currentColor = Color(0xff443a49);
//   String apiUrl = "";
//   void changeColor(Color color) {
//     setState(() => pickerColor = color);
//   }

//   String _primaryColor = "";
//   String token = '';
//   FlutterSecureStorage storage = FlutterSecureStorage();
//   final ImagePicker _picker = ImagePicker();
//   PickedFile? _imageFile;
//   PickedFile? _imageFilec;
//   final httpUserHandler = HttpUserHandler();
//   List<User>? users;
//   Activity? selectedActivity = Activity();

//   bool chech = true;
//   @override
//   void initState() {
//     super.initState();
//     loadBaseUrl();
//     pickerColor = Color(0xff443a49);
//     _primaryColor = pickerColor.value.toRadixString(16).substring(2, 8);
//     updatedValue = widget.initialValue;
//     // if (updatedValue == 'Man') {
//     //   selectedIndex = 0;
//     // } else if (updatedValue == 'Woman') {
//     //   selectedIndex = 1;
//     // } else {
//     //   selectedIndex = 2;
//     // }
//   }

//   Future<String> loadBaseUrl() async {
//     baseUrl = await storage.read(key: "baseurl");
//     return baseUrl ?? ""; // Return an empty string if baseUrl is null
//   }

//   void updateUserDetail(String field, String updatedValue) async {
//     // baseUrl = await storage.read(key: "baseurl");
  

//     final String token = await storage.read(key: "access_token");

//     try {
//       if (field == 'primaryColor' || field == 'secondaryColor') {
//         apiUrl =
//             '$baseUrls/api/activity-templates/${widget.activity.activityTemplate!.id}';
//       } else {
//         apiUrl = '${widget.baseUrl}/api/activities/${widget.activity.id}';
//       }
//       final response = await http.patch(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//         body: {field: updatedValue},
//       );

//       if (response.statusCode == 200) {
//         print('$field updated successfully');
//         if (mounted) {
//           setState(() {
//             switch (field) {
//               case 'name':
//                 selectedActivity?.name = updatedValue;
//                 break;
//               case 'babyPrice':
//                 selectedActivity?.babyPrice = double.tryParse(updatedValue);
//                 break;
//               case 'primaryColor':
//                 selectedActivity?.activityTemplate?.primaryColor = updatedValue;
//                 break;
//               case 'secondaryColor':
//                 selectedActivity?.activityTemplate?.secondaryColor =
//                     updatedValue;

//                 break;
//               case 'logo':
//                 selectedActivity?.activityTemplate!.logo = updatedValue;
//                 break;
//               // case 'address':
//               //   selectedActivity?.address = updatedValue;
//               //   break;
//               // case 'phone':
//               //   selectedActivity?.phone = updatedValue;
//               //   break;
//               // case 'lastName':
//               //   selectedActivity?.lastName = updatedValue;
//               //   break;
//               // case 'zipCode':
//               //   selectedActivity?.zipCode = updatedValue;
//               //   break;
//               // case 'birthDate ':
//               //   selectedActivity?.birthDate = DateTime.parse(updatedValue);
//               //   break;
//               // Add more cases for other fields as needed
//             }
//           });
//         } else {
//           print('Failed to update $field');
//           print('Token: $token');

//           print('Base URL: $baseUrl');
//           print('API URL: $apiUrl');
//         }
//       }
//     } catch (error) {
//       print('Error occurred while updating $field: $error');
//     }
//   }

//   void updateActivitytemplateDetail(String field, String updatedValue) async {
//     // baseUrl = await storage.read(key: "baseurl");
//     final String apiUrl =
//         '${widget.baseUrl}/api/activities/${widget.activity.id}';
//     final String token = await storage.read(key: "access_token");

//     try {
//       final response = await http.patch(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//         body: {field: updatedValue},
//       );

//       if (response.statusCode == 200) {
//         print('$field updated successfully');
//         if (mounted) {
//           setState(() {
//             switch (field) {
//               case 'name':
//                 selectedActivity?.name = updatedValue;
//                 break;
//               case 'babyPrice':
//                 selectedActivity?.babyPrice = double.tryParse(updatedValue);
//                 break;
//               case 'primaryColor':
//                 selectedActivity?.activityTemplate?.primaryColor = updatedValue;
//                 break;
//               case 'secondaryColor':
//                 selectedActivity?.activityTemplate?.secondaryColor =
//                     updatedValue;

//                 break;
//               case 'logo':
//                 selectedActivity?.activityTemplate!.logo = updatedValue;
//                 break;
//               // case 'address':
//               //   selectedActivity?.address = updatedValue;
//               //   break;
//               // case 'phone':
//               //   selectedActivity?.phone = updatedValue;
//               //   break;
//               // case 'lastName':
//               //   selectedActivity?.lastName = updatedValue;
//               //   break;
//               // case 'zipCode':
//               //   selectedActivity?.zipCode = updatedValue;
//               //   break;
//               // case 'birthDate ':
//               //   selectedActivity?.birthDate = DateTime.parse(updatedValue);
//               //   break;
//               // Add more cases for other fields as needed
//             }
//           });
//         } else {
//           print('Failed to update $field');
//           print('Token: $token');

//           print('Base URL: $baseUrl');
//           print('API URL: $apiUrl');
//         }
//       }
//     } catch (error) {
//       print('Error occurred while updating $field: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       iconColor: Colors.blue,
//       icon: Icon(Icons.update),
//       backgroundColor: Color.fromARGB(199, 243, 242, 242),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20), // Adjust the border radius
//       ),
//       title: Text('Do you wanna change your ${widget.field}'),
//       content: TextField(
//         controller: TextEditingController(text: widget.initialValue),
//         onChanged: (value) {
//           updatedValue = value;
//         },
//       ),
//       actions: [
//         ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(
//                 208, 5, 25, 199)), // Set the desired background color
//           ),
//           onPressed: () async {
//             // updateUserDetail(widget.field, updatedValue);
//             // widget.onUpdateDetail(widget.field, updatedValue);

//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: Text('Close'),
//         ),
//         ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(
//                 208, 216, 13, 13)), // Set the desired background color
//           ),
//           onPressed: () async {
//             if (updatedValue.isNotEmpty) {
//               updateUserDetail(widget.field, updatedValue);
//               widget.onUpdateDetail(widget.field, updatedValue);

//               Navigator.of(context).pop();
//             } else {
//               print("ff");
//             }
//             // Close the dialog
//           },
//           child: Text('save'),
//         )
//       ],
//     );
//   }
// }
