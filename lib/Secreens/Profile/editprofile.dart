import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../NetworkHandler.dart';

import '../../constent.dart';
import '../../modele/HttpUserHandler.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../modele/planningmainModel.dart';

import 'CreatProfile.dart';
import 'UpdateUserDetailDialog.dart';
import 'package:flutter_svg/svg.dart';

String? baseUrl = "";

class MainProfile extends StatefulWidget {
  const MainProfile({Key? key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  String token = '';
  final httpUserHandler = HttpUserHandler();
  List<User>? users;
  User? selectedUser = User();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  get selectedPlanning => PlanningMainModel();

  TouristGuide? get selectedTouristGuide => TouristGuide();
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
      final user = await httpUserHandler.fetchUser('/api/users/$userId',"$token");

      setState(() {
        users = [user];
        selectedUser = user;
        circular = false;
      });
      if (user.email == null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreatProfile()),
        );
      }
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  void updateUserDetail(String field, String updatedValue) async {
    final String? userId =
        await storage.read(key: "id"); // Replace with the actual user ID
    final String? baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '$baseUrls/api/users/$userId';
    final String? token = await storage.read(key: "access_token");

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
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
            case 'password ':
              selectedUser?.password = updatedValue;
              break;
            // Add more cases for other fields as needed
          }
        });
      } else {
        print('Failed to update $field');
        print('Token: $token');
        print('User ID: $userId');
        print('Base URL: $baseUrls');
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
      } else if (field == 'password') {
        selectedUser?.password = updatedValue;
      }
      // Add more conditions for other fields if needed
    });
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
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF3A3557),
                    Color(0xFFCBA36E),
                    Color(0xFFEB5F52),
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                'Your Profil',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors
                      .white, // You can adjust the font size and color here
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: circular
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    shape: BeveledRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 239, 236, 236)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: head(),
                  ),
                  const Divider(
                    thickness: 0.8,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
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
                  ElevatedButton(
                    onPressed: () {
                      showPasswordUpdateDialog(context); // Pass the context
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFFEB5F52), // Set the background color
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white, // Set the text color
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'phone', selectedUser?.phone ?? '');
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.phone,
                          color: Color.fromARGB(210, 13, 2, 165),
                          size: 22.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Phone: ${selectedUser?.phone ?? 'No phone available'}",
                          style: const TextStyle(
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
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.person,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        const SizedBox(
                            width:
                                8), // Adding some spacing between icon and text
                        Text(
                          'lastName: ${selectedUser?.lastName ?? ""}',
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
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.man,
                              color: Color.fromARGB(210, 13, 2, 165),
                            ),
                            const SizedBox(
                                width:
                                    8), // Adding spacing between icon and text
                            Text(
                              'gender: ${selectedUser?.gender ?? ""}',
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
                            child: const Row(
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
                        const SizedBox(
                            width: 10), // Adding space before the icon
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        const SizedBox(
                            width: 8), // Adding spacing between icon and text
                        Text(
                          'Address: ${selectedUser?.address ?? ""}',
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
                  const SizedBox(
                      height: 20), // Adding space after the first section
                  InkWell(
                    onDoubleTap: () {
                      updateUserDetailDialog(
                          'zipCode', selectedUser?.zipCode ?? '');
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 10), // Adding space before the icon
                        const Icon(
                          Icons.cottage_rounded,
                          color: Color.fromARGB(210, 13, 2, 165),
                        ),
                        const SizedBox(
                            width: 8), // Adding spacing between icon and text
                        Text(
                          'Zip Code: ${selectedUser?.zipCode ?? ""}',
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
      // bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

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
                            '$baseUrls/assets/uploads/Mobile/picture/${selectedUser?.picture}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                            headers: {
                              'Authorization': 'Bearer $token',
                            },
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: InkWell(
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
          icon: const Icon(Icons.update),
          backgroundColor: const Color.fromARGB(199, 243, 242, 242),
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
                    const Color.fromARGB(
                        208, 21, 109, 224)), // Set the desired background color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(
                        208, 216, 13, 13)), // Set the desired background color
              ),
              onPressed: () {
                // Implement the logic to update the user detail
                updateUserDetail(field, updatedValue);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showPasswordUpdateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          String oldPassword = '';
          String newPassword = '';
          String confirmPassword = '';

          return AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    oldPassword = value;
                  },
                  decoration: const InputDecoration(labelText: 'Old Password'),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    newPassword = value;
                  },
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Confirm New Password'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Call the password update function here
                  await updatePassword(oldPassword, newPassword);

                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final String? userId = await storage.read(key: "id");
    final String? baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '$baseUrls/api/users/$userId/update-password';
    final String? token = await storage.read(key: "access_token");

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        print('Password updated successfully');
        // Show a success message to the user
      } else {
        print('Failed to update password');
        // Show an error message to the user
      }
    } catch (error) {
      print('Error occurred while updating password: $error');
      // Show an error message to the user
    }
  }
}
