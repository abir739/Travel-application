import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../NetworkHandler.dart';
import '../../constent.dart';

import '../../modele/HttpUserHandler.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:http/http.dart' as http;

import '../PlannigSecreen.dart';
import 'CreatProfile.dart';

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
  // final _globalkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _about = TextEditingController();

  NetworkHandler networkHandler = NetworkHandler();

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUser();
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
          MaterialPageRoute(builder: (context) => const CreatProfile()),
        );
      }
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final String? userId = await storage.read(key: "id");
    final String? baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '$baseUrls/api/users/$userId';
    final String? token = await storage.read(key: "access_token");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: circular
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    shape: BeveledRectangleBorder(
                      side:
                          const BorderSide(color: Color.fromARGB(255, 239, 236, 236)),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  Text(
                    "Phone: ${selectedUser?.phone ?? 'No phone available'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(210, 14, 14, 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
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
                        ElevatedButton(
                          onPressed: () {
                            showPasswordUpdateDialog(
                                context); // Show a dialog to update the password
                          },
                          child: const Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
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
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
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
  final String apiUrl = '$baseUrls/api/users/$userId';
  final String? token = await storage.read(key: "access_token");

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
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
