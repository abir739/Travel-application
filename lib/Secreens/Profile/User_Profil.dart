import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zenify_trip/Secreens/login_test.dart';
import '../../NetworkHandler.dart';
import '../../constent.dart';
import '../../modele/HttpUserHandler.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:http/http.dart' as http;
import '../../modele/planningmainModel.dart';
import 'CreatProfile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenify_trip/Secreens/Upload_Files/FileUploadScreen.dart';
import 'package:get/get.dart';

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
  final RefreshController _refreshController = RefreshController();
  TouristGuide? get selectedTouristGuide => TouristGuide();
  @override
  void initState() {
    super.initState();
    _loadUser();
    // fetchData();
  }

  Future<void> _onRefresh() async {
    _loadUser();

    _refreshController.refreshCompleted();
  }

  void _loadUser() async {
    token = (await storage.read(key: "access_token"))!;
    baseUrl = await storage.read(key: "baseurl");
    setState(() {
      users = []; // initialize the list to an empty list
    });
    print("token, $token");
    final userId = await storage.read(key: "id");
    try {
      final user =
          await httpUserHandler.fetchUser('/api/users/$userId', "$token");

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
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 137, 219),
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
                'Profil',
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildMainInfo(context, widthC),
            const SizedBox(height: 10.0),
            _buildInfo(context, widthC),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Future<void> _updateProfilePicture() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final String? userId =
            await storage.read(key: "id"); // Replace with the actual user ID
        final String? baseUrl = await storage.read(key: "baseurl");
        final String apiUrl = '$baseUrls/api/users/$userId';
        //final String apiUrl = '$baseUrl/api/users/$userId/update-profile-picture';
        final String? token = await storage.read(key: "access_token");

        // Ensure that baseUrls is not null and has a valid format
        if (baseUrl == null) {
          print('Base URL is null');
          return;
        }

        var request = http.MultipartRequest('PATCH', Uri.parse(apiUrl))
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(await http.MultipartFile.fromPath(
              'profilePicture', pickedFile.path));

        try {
          final response = await request.send();
          if (response.statusCode == 200) {
            // Update the user's profile picture on success
            setState(() {
              selectedUser?.picture = pickedFile.path;
            });
          } else {
            print('Failed to update profile picture');
          }
        } catch (error) {
          print('Error occurred while updating profile picture: $error');
        }
      }
    }

    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://img.freepik.com/free-vector/travel-time-typography-design_1308-90406.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        GestureDetector(
          onTap: _updateProfilePicture,
          // onTap: () async {
          //   final newData = await Get.to(FileUploadScreen(
          //       dynamicPath: 'profile',
          //       id: selectedUser?.id ?? "",
          //       fild: 'picture',
          //       object: "api/users"));
          //   if (newData != null) {
          //     // You can use newData here
          //     print("Received data from FileUploadScreen: $newData");
          //     setState(() {
          //       _onRefresh();
          //     });
          //   } else {
          //     // Handle the case where newData is null
          //     print("No data received from FileUploadScreen");
          //   }
          // },

          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 140),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  color: Colors.grey.shade500,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white,
                        width: 6.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        // child: selectedUser?.picture != null
                        //     ? Image.network(
                        //         selectedUser?.picture ??
                        //             'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                        //         width: 80,
                        //         height: 80,
                        //         fit: BoxFit.fill,
                        //       )
                        //     : Image.network(
                        //         '${baseUrls}/assets/uploads/profil/${selectedUser?.picture}',
                        //         fit: BoxFit.cover,
                        //       ),
                        child: Image.network(
                          selectedUser?.picture ??
                              'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${selectedUser?.firstName} ${selectedUser?.lastName}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedUser?.username ??
                'Unknown Username', // Fallback value if null
            style: TextStyle(
              color: Colors.grey.shade50,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, double width) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("E-Mail"),
                subtitle: Text(selectedUser?.email ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Phone Number"),
                subtitle: Text(selectedUser?.phone ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cake,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Birth Date"),
                subtitle: Text(
                  selectedUser?.birthDate?.toString() ?? 'N/A',
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: const Icon(
                  Icons.my_location,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Location"),
                subtitle: Text(selectedUser?.address ?? 'N/A'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showPasswordUpdateDialog(context); // Pass the context
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 94, 36, 228), // Set the background color
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white, // Set the text color
                  ),
                ),
              ),
            ],
          ),
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
