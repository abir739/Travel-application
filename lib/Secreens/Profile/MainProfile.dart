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
if(user.gender==null){
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
     
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.only(top: 10),
                    shape: BeveledRectangleBorder(
                      side: BorderSide(color: Color.fromARGB(0, 239, 236, 236)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: head()),
                Divider(
                  thickness: 0.8,
                ),
                Row(
                  children: [
                    otherDetails("email", selectedUser?.email ?? "", Icons.email),
                  ],
                ),
                Row(
                  mainAxisAlignment :MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      //  onLongPress: updatePhoneNumberDialog,
                      onDoubleTap: () {
                        updateUserDetailDialog(
                            'lastName', selectedUser?.lastName ?? '');
                      },
                      child: otherDetails(
                          "lastName", selectedUser?.lastName ?? "", Icons.person),
                    ),
                    InkWell(
                      child: Icon(
                      Icons.wifi_protected_setup_rounded,
                        color: Color.fromARGB(210, 13, 2, 165),
                      ),
                      onTap: () {
                        updateUserDetailDialog(
                            'lastName', selectedUser?.lastName ?? '');
                      },
                    ),
                  ],
                ), Row(
                  mainAxisAlignment :MainAxisAlignment.spaceBetween,
                  children: [
                InkWell(
                    //  onLongPress: updatePhoneNumberDialog,
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
                    child: otherDetails(
                "gender", selectedUser?.gender ?? "", Icons.man)),
                      InkWell(
                        child: Icon(
                          Icons.wifi_protected_setup_rounded,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
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
                      ),
                    ]),
                InkWell(
                  //  onLongPress: updatePhoneNumberDialog,
                  onDoubleTap: () {
                    updateUserDetailDialog(
                        'address', selectedUser?.address ?? '');
                  },
                  child: otherDetails("Address", selectedUser?.address ?? " ",
                      Icons.location_on_outlined),
                ),
                InkWell(
                  //  onLongPress: updatePhoneNumberDialog,
                  onDoubleTap: () {
                    updateUserDetailDialog(
                        'zipCode', selectedUser?.zipCode ?? '');
                  },
                  child: otherDetails("zip code", selectedUser?.zipCode ?? " ",
                      Icons.cottage_rounded),
                ),
                InkWell(
                  onDoubleTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      initialEntryMode :DatePickerEntryMode.calendar,
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
                        0, // Set the time component to 0
                        0, // Set the time component to 0
                      ).toLocal(); // Convert to local time zone
                      updateUserDetail('birthDate', updatedDateTime.toString() ?? "");
                    }
                  },
                  child: otherDetails(
                    "birthDate",
                    selectedUser?.birthDate.toString() ?? "",
                    Icons.calendar_today,
                  ),
                ),

                // otherDetails(
                //     "gender", selectedUser?.gender.toString() ?? ""),
                // Icons.calendar_today,
                // otherDetails("Profession", "profileModel.profession"),
                // otherDetails("DOB", "profileModel.DOB"),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                // Blogs(
                //   url: "/blogpost/getOwnBlog",
                // ),
              ],
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
    // final top = pictureHigth - logoHigth;
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
    Container(
                padding:
                    EdgeInsets.all(4.0), // Adjust the padding values as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(225, 255, 255, 255),
                ),
                child: selectedUser?.picture == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: Image.network(
                          'https://st4.depositphotos.com/15648834/23779/v/450/depositphotos_237795804-stock-illustration-unknown-person-silhouette-profile-picture.jpg',
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                          fit: BoxFit.cover,
                        ).image,
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: Image.network(
                          '${baseUrls}/assets/uploads/Mobile/picture/${selectedUser?.picture}',
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                          fit: BoxFit.cover,
                        ).image,
                      ),
              ),
//             Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   SizedBox(
//                     height: Get.height * 0.22,
//                     width: Get.width * 1,
//                     child: selectedUser?.picture ==null ?Image.network(
//                       'https://st4.depositphotos.com/15648834/23779/v/450/depositphotos_237795804-stock-illustration-unknown-person-silhouette-profile-picture.jpg',

//                       headers: {
//                         'Authorization': 'Bearer $token',
//                       },
//                       fit: BoxFit.cover,
//                     ): Image.network(
//                             '${baseUrls}/assets/uploads/Mobile/picture/${selectedUser?.picture}',
//                             headers: {
//                               'Authorization': 'Bearer $token',
//                             },
//                             fit: BoxFit.cover,
//                           ),
//                   ),
//                   Positioned(
//                     bottom: 20.0,
//                     right: 20.0,
//                     child: InkWell(
//                       onTap: () {
//                         // showModalBottomSheet(
//                         //   context: context,
//                         //   builder: ((builder) => bottomSheetC()),
//                         // );
// Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => FileUploadScreen(
//                                 dynamicPath:
//                                     'Mobile/picture',
//                                 id:
//                                     selectedUser!.id ??"" ,
//                                 fild:
//                                     'picture',object: "api/users",), // Replace with your dynamic path
//                           ),
//                         );
//                       },
//                       child: Icon(
//                         Icons.camera_sharp,
//                         color: Color.fromARGB(149, 241, 244, 243),
//                         size: 28.0,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 120,
//                     left: 40,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Stack(clipBehavior: Clip.none, children: [
//                         Container(
//                           padding: EdgeInsets.all(
//                               3.0), // Adjust the padding values as needed
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color.fromARGB(197, 255, 255, 255),
//                           ),
//                           child:selectedUser?.picture==null? CircleAvatar(
//                             radius: 50,
//                             backgroundImage: Image.network(
//                               'https://st4.depositphotos.com/15648834/23779/v/450/depositphotos_237795804-stock-illustration-unknown-person-silhouette-profile-picture.jpg',
//                               headers: {
//                                 'Authorization': 'Bearer $token',
//                               },
//                               fit: BoxFit.cover,
//                             ).image,
//                           ): CircleAvatar(
//                                   radius: 50,
//                                   backgroundImage: Image.network(
//                                     '${baseUrls}/assets/uploads/Mobile/picture/${selectedUser?.picture}',
//                                     headers: {
//                                       'Authorization': 'Bearer $token',
//                                     },
//                                     fit: BoxFit.cover,
//                                   ).image,
//                                 ),
//                         ),
//                         Positioned(
//                           top: 12.0,
//                           right: 60.0,
//                           child: InkWell(
//                             onTap: () {
//                               showModalBottomSheet(
//                                 context: context,
//                                 builder: ((builder) => bottomSheet()),
//                               );
//                               print("hi");
//                             },
//                             child: Icon(
//                               Icons.camera_alt,
//                               color: Color.fromARGB(223, 134, 137, 137),
//                               size: 28.0,
//                             ),
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
           
 ],
          ),
          SizedBox(height: 80),
          Divider(
            color: Color.fromARGB(147, 6, 6, 194),
          ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                //  onLongPress: updatePhoneNumberDialog,
                onDoubleTap: () {
                  updateUserDetailDialog('phone', selectedUser?.phone ?? '');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(147, 6, 6, 194),
                      size: 28.0,
                    ),
                    Text(
                      "  Phone: ${selectedUser?.phone ?? 'No phone available'}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "(${selectedUser?.lastName})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "(${selectedUser?.firstName})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "(${selectedUser?.username})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
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
                    Color.fromARGB(208, 21, 109, 224)), // Set the desired background color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(style:
                ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(208, 216, 13,
                          13)), // Set the desired background color
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
  
      child:     label == "birthDate"
          ?Column(
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
           DateFormat('  MMMM  d ,y ')
                                        .format(DateTime.parse(value!)),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 233, 7, 7)),
          )
        ],
      )
:Column(
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
