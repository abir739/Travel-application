import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../NetworkHandler.dart';
import '../../modele/HttpUserHandler.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class UpdateUserDetailDialogC extends StatefulWidget {
  final String field;
  final String initialValue;
final Function(String, String) onUpdateDetail; 
  const UpdateUserDetailDialogC({
    required this.field,
    required this.initialValue,
    required this.onUpdateDetail,
  });

  @override
  _UpdateUserDetailDialogCState createState() => _UpdateUserDetailDialogCState();
}

class _UpdateUserDetailDialogCState extends State<UpdateUserDetailDialogC> {
  String updatedValue = '';
  int selectedIndex = -1;
bool circular = true;
  String token = '';
FlutterSecureStorage storage = FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  PickedFile? _imageFilec;
  final httpUserHandler = HttpUserHandler();
  List<User>? users;
  User? selectedUser = User();
  @override
  void initState() {
    super.initState();
    updatedValue = widget.initialValue;
    if (updatedValue == 'Man') {
      selectedIndex = 0;
    } else if (updatedValue == 'Woman') {
      selectedIndex = 1;
    } else {
      selectedIndex = 2;
    }
  }
void updateUserDetail(String field, String updatedValue) async {
    final String? userId =
        await storage.read(key: "id"); // Replace with the actual user ID
    final String? baseUrl = await storage.read(key: "baseurl");
    final String? apiUrl = '$baseUrl/api/users/$userId';
    final String? token = await storage.read(key: "access_token");

    try {
      final response = await http.patch(
        Uri.parse(apiUrl!),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {field: updatedValue},
      );

      if (response.statusCode == 200) {
        print('$field updated successfully');
        setState(() {
          switch (field) {
            case 'email':
              selectedUser?.email = updatedValue;
              break;
            case 'LastName':
              selectedUser?.lastName = updatedValue;
              break;
            case 'gender':
              selectedUser?.gender = updatedValue;
              break;
            case 'address':
              selectedUser?.address = updatedValue;
              break;
            case 'phone':
              selectedUser?.phone = updatedValue;
              break;
            case 'lastName':
              selectedUser?.lastName = updatedValue;
              break;
            case 'zipCode':
              selectedUser?.zipCode = updatedValue;
              break;
            case 'birthDate ':
              selectedUser?.birthDate = DateTime.parse(updatedValue);
              break;
            // Add more cases for other fields as needed
          }
        });
      } else {
        print('Failed to update $field');
        print('Token: $token');
        print('User ID: $userId');
        print('Base URL: $baseUrl');
        print('API URL: $apiUrl');
      }
    } catch (error) {
      print('Error occurred while updating $field: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(iconColor:Colors.blue,icon: Icon(Icons.update),backgroundColor: Color.fromARGB(199, 243, 242, 242),shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the border radius
                            ),
      title: Text('Pike Your ${widget.field}'),
      content: widget.field == 'gender'
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Man'),trailing:Icon(Icons.man),
                  leading: Radio<int>(
                    value: 0,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = value ?? 0;
                        updatedValue = 'Man';
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      updatedValue = 'Man';
                    });
                  },
                ),
                ListTile(
                  title: const Text('Woman'),
                  trailing: Icon(Icons.woman),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = value ?? 0;
                        updatedValue = 'Woman';
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                      updatedValue = 'Woman';
                    });
                  },
                ),
                ListTile(
                  title: const Text('Other'),
                  trailing: Icon(Icons.hotel_sharp),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = value ?? 0;
                        updatedValue = 'Other';
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                      updatedValue = 'Other';
                    });
                  },
                ),
              ],
            )
          : TextField(
              controller: TextEditingController(text: widget.initialValue),
              onChanged: (value) {
                updatedValue = value;
              },
            ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(
                208, 216, 13, 13)), // Set the desired background color
          ),
          onPressed: () {
            widget.onUpdateDetail(widget.field, updatedValue);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('save'),
        ),
       
      ],
    );
  }
}
