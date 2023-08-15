import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../NetworkHandler.dart';
import '../../constent.dart';
import '../../modele/HttpUserHandler.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'CreatProfile.dart';
import 'UpdateUserDetailDialog.dart';

// import '../../models/profileModel.dart';
String? baseUrl = "";

class MainProfile extends StatefulWidget {
  MainProfile({Key? key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  String token = '';
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  PickedFile? _imageFilec;
  final httpUserHandler = HttpUserHandler();
  List<User>? users;
  User? selectedUser = User();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();

  NetworkHandler networkHandler = NetworkHandler();
  // ProfileModel profileModel = ProfileModel();

  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUser();
    // fetchData();
  }

  void _loadUser() async {
    token = (await storage.read(key: "access_token"))!;
    baseUrl = await storage.read(key: "baseurl");
    setState(() {
      users = []; // initialize the list to an empty list
    });

    final userId = await storage.read(key: "id");
    try {
      final user = await httpUserHandler.fetchUser('/api/users/$userId');

      setState(() {
        users = [user];
        selectedUser = user;
        circular = false;
      });
      if (user.gender == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreatProfile()),
        );
      }
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  void updatePhoneNumber(String updatedPhoneNumber) async {
    final userId =
        await storage.read(key: "id"); // Replace with the actual user ID
    baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '${baseUrls}/api/users/$userId';
    token = (await storage.read(key: "access_token"))!;
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {'phone': updatedPhoneNumber},
      );

      if (response.statusCode == 200) {
        print('Phone number updated successfully');
        setState(() {
          selectedUser?.phone = updatedPhoneNumber;
        });
      } else {
        print('Failed to update phone number');
        print('$token');
        print('$userId');
        print('${baseUrls}');
        print('$apiUrl');
        print('Failed to update phone number');
      }
    } catch (error) {
      print('Error occurred while updating phone number: $error');
    }
  }

  void updateUserDetail(String field, String updatedValue) async {
    final String? userId =
        await storage.read(key: "id"); // Replace with the actual user ID
    final String? baseUrl = await storage.read(key: "baseurl");
    final String? apiUrl = '${baseUrls}/api/users/$userId';
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
        print('Base URL: ${baseUrls}');
        print('API URL: $apiUrl');
      }
    } catch (error) {
      print('Error occurred while updating $field: $error');
    }
  }

  void handleDetailUpdate(String field, String updatedValue) {
    // Update the screen detail based on the field and updated value
    setState(() {
      if (field == 'gender') {
        selectedUser?.gender = updatedValue;
      } else if (field == 'phone') {
        selectedUser?.phone = updatedValue;
      } else if (field == 'email') {
        selectedUser?.email = updatedValue;
      }
      // Add more conditions for other fields if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: circular
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(top: 10),
                    shape: BeveledRectangleBorder(
                      side:
                          BorderSide(color: Color.fromARGB(255, 239, 236, 236)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: head(),
                  ),
                  const Divider(
                    thickness: 0.8,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      const Icon(
                        Icons.email,
                        color: Color.fromARGB(210, 13, 2, 165),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Email: ${selectedUser?.email ?? ""}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(210, 14, 14, 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'phone', selectedUser?.phone ?? '');
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.phone,
                          color: Color.fromARGB(210, 13, 2, 165),
                          size: 22.0,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Phone: ${selectedUser?.phone ?? 'No phone available'}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(210, 14, 14, 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'lastName', selectedUser?.lastName ?? '');
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        SizedBox(
                            width:
                                8), // Adding some spacing between icon and text
                        Text(
                          'lastName: ${selectedUser?.lastName ?? ""}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                                210, 14, 14, 15), // Set the text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => UpdateUserDetailDialogC(
                              field: 'gender',
                              initialValue: selectedUser?.gender ?? '',
                              onUpdateDetail: handleDetailUpdate,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.man,
                              color: Color.fromARGB(210, 13, 2, 165),
                            ),
                            SizedBox(
                                width:
                                    8), // Adding spacing between icon and text
                            Text(
                              'gender: ${selectedUser?.gender ?? ""}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(
                                    210, 14, 14, 15), // Set the text color
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateUserDetailDialogC(
                                  field: 'gender',
                                  initialValue: selectedUser?.gender ?? '',
                                  onUpdateDetail: handleDetailUpdate,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 10), // Adding space before the icon
                                Icon(
                                  Icons.wifi_protected_setup_rounded,
                                  color: Color.fromARGB(210, 13, 2, 165),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'address', selectedUser?.address ?? '');
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10), // Adding space before the icon
                        Icon(
                          Icons.location_on_outlined,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        SizedBox(
                            width: 8), // Adding spacing between icon and text
                        Text(
                          'Address: ${selectedUser?.address ?? ""}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                                210, 14, 14, 15), // Set the text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Adding space after the first section
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'zipCode', selectedUser?.zipCode ?? '');
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10), // Adding space before the icon
                        Icon(
                          Icons.cottage_rounded,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        SizedBox(
                            width: 8), // Adding spacing between icon and text
                        Text(
                          'Zip Code: ${selectedUser?.zipCode ?? ""}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                                210, 14, 14, 15), // Set the text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Adding space after the second section
                  InkWell(
                    onDoubleTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        initialEntryMode: DatePickerEntryMode.calendar,
                        context: context,
                        initialDate: selectedUser?.birthDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        final updatedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day + 1,
                          0,
                          0,
                        ).toLocal();
                        updateUserDetail(
                            'birthDate', updatedDateTime.toString());
                      }
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 10), // Adding space before the icon
                        const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        const SizedBox(
                            width: 8), // Adding spacing between icon and text
                        Text(
                          'Birth Date: ${selectedUser?.birthDate.toString() ?? ""}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                                210, 14, 14, 15), // Set the text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

//   Widget head() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//         Center(
//           child: CircleAvatar(
//             radius: 50,
//             backgroundImage: Image.network(
//               '${baseUrls}/api/users/uploads/${selectedUser?.logo}',
//               headers: {
//                 'Authorization': 'Bearer $token',
//               },
//               fit: BoxFit.cover,
//             ).image,
//           ),
//         ),
// // CircleAvatar(
// //               radius: 50,
// //               backgroundImage: NetworkHandler()
// //                   .getImage("profileModel.username ?? 'username'"),
// //             ),

//           Text(
//             "Phone :${selectedUser?.phone}",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             " (${selectedUser?.lastName})",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 10,
//           ),

//         ],
//       ),
//     );
//   }
  Widget head() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.38,
                  width: Get.width * 0.78,
                  child: ClipOval(
                    child: selectedUser?.picture == null
                        ? Image.network(
                            'https://st4.depositphotos.com/15648834/23779/v/450/depositphotos_237795804-stock-illustration-unknown-person-silhouette-profile-picture.jpg',
                            headers: {
                              'Authorization': 'Bearer $token',
                            },
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            '${baseUrls}/assets/uploads/Mobile/picture/${selectedUser?.picture}',
                            headers: {
                              'Authorization': 'Bearer $token',
                            },
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                      print("hi");
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: Color.fromARGB(223, 134, 137, 137),
                      size: 28.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void updatePhoneNumberDialog() {
    String updatedPhoneNumber = selectedUser?.phone ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Phone Number'),
          content: TextField(
            controller: TextEditingController(text: updatedPhoneNumber),
            onChanged: (value) {
              updatedPhoneNumber = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to update the phone number
                updatePhoneNumber(updatedPhoneNumber);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
// void updateUserDetailDialog(String field, String initialValue) {
//     String updatedValue = initialValue;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Update $field'),
//           content: TextField(
//             controller: TextEditingController(text: updatedValue),
//             onChanged: (value) {
//               updatedValue = value;
//             },
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement the logic to update the user detail
//                 updateUserDetail(field, updatedValue);
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// void updateUserDetailDialog(String field, String initialValue) {
//   String updatedValue = initialValue;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Update $field'),
//         content: TextField(
//           controller: TextEditingController(text: updatedValue),
//           onChanged: (value) {
//             updatedValue = value;
//           },
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Implement the logic to update the user detail
//               updateUserDetail(field, updatedValue);
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Update'),
//           ),
//         ],
//       );
//     },
//   );
// }

  void updateUserDetailDialog(String field, String initialValue) {
    String updatedValue = initialValue;
    int selectedIndex = initialValue == 'Man'
        ? 0
        : initialValue == 'Woman'
            ? 1
            : 2;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          iconColor: Colors.blue,
          icon: Icon(Icons.update),
          backgroundColor: Color.fromARGB(199, 243, 242, 242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Adjust the border radius
          ),
          title: Text('Update $field'),
          content: field == "gender"
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Man'),
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
                  controller: TextEditingController(text: updatedValue),
                  onChanged: (value) {
                    updatedValue = value;
                  },
                ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(
                        208, 21, 109, 224)), // Set the desired background color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(
                        208, 216, 13, 13)), // Set the desired background color
              ),
              onPressed: () {
                // Implement the logic to update the user detail
                updateUserDetail(field, updatedValue);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget otherDetails(String? label, String? value, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: label == "birthDate"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      iconData,
                      color: Color.fromARGB(210, 13, 2, 165),
                    ),
                    Text(
                      " $label : ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 17, 107),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  width: 8,
                ),
                Text(
                  DateFormat('  MMMM  d ,y ').format(DateTime.parse(value!)),
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 233, 7, 7)),
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      iconData,
                      color: Color.fromARGB(210, 13, 2, 165),
                    ),
                    Text(
                      " $label : ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 17, 107),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                  width: 8,
                ),
                Text(
                  value!,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(184, 46, 46, 49),
                  ),
                )
              ],
            ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Widget bottomSheetC() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Covert  photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhotoC(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhotoC(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }

  void takePhotoC(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFilec = pickedFile!;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Dev Stack",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Full Stack Developer",
      ),
    );
  }

  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value!.isEmpty) return "DOB can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromARGB(255, 181, 185, 181),
        ),
        labelText: "Date Of Birth",
        helperText: "Provide DOB on dd/mm/yyyy",
        hintText: "01/01/2020",
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) return "Title can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }
}
