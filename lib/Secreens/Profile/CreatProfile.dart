import 'dart:io';



import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../guidPlannig.dart';
import './MainProfile.dart';
import '../../NetworkHandler.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class CreatProfile extends StatefulWidget {
  CreatProfile({Key? key}) : super(key: key);

  @override
  _CreatProfileState createState() => _CreatProfileState();
}

class _CreatProfileState extends State<CreatProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
    PickedFile? _imageFile;
  // final _globalkey = GlobalKey<FormState>();
GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _adddres = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  final ImagePicker _picker = ImagePicker();
FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            adddres(),
            SizedBox(
              height: 20,
            ),
            // dobField(),
            // SizedBox(
            //   height: 20,
            // ),
            titleTextField(),
            SizedBox(
              height: 20,
            ),
            aboutTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
              
                if (formKey.currentState!.validate()) {
                  setState(() {
                    circular = true;
                  });
                  Map<String, String> data = {
                    "lastName": _name.text,
                    // "username": _name.text,
                    "gender":zipCode.text,
                    // "birthDate": _dob.text,
                    "address":  _adddres.text,
                    "zipCode": zipCode.text,
                  };
                  final String? userId = await storage.read(
                      key: "id"); // Replace with the actual user ID
                  final String? baseUrl = await storage.read(key: "baseurl");
                  final String? apiUrl = '$baseUrl/api/users/$userId';
                  final String? token = await storage.read(key: "access_token");
                  // var response =
                  //     await networkHandler.post("/profile/add", data);
                  final response = await http.patch(
                    Uri.parse(apiUrl!),
                    headers: {
                      'Authorization': 'Bearer $token',
                    },
                    body: data,
                  );
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
              setState(() {
                      circular = false;
                    }); 
    Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainProfile()),
                              );
                    // print('$_imageFile.path image path');
                    if (_imageFile != null) {
                      print(_imageFile);
                      var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image", _imageFile!.path);
                      if (imageResponse.statusCode == 200) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => PlaningSecreen()),
                            (route) => false);
                      }
                    } else {
                      setState(() {
                        print(_imageFile!.path);
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => PlaningSecreen()),
                          (route) => false);
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                     color: Color.fromARGB(255, 6, 70, 189),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
 _imageFile != null ?
       CircleAvatar(
          radius: 80.0,
          backgroundImage:
              
            FileImage(File(_imageFile!.path)),
        ):CircleAvatar(
          radius: 80.0,
          backgroundImage:
              
             AssetImage("assets/profile.jpeg")),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
               color: Color.fromARGB(255, 6, 70, 189),
              size: 28.0,
            ),
          ),
        ),
      ]),
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
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
          color: Color.fromARGB(255, 6, 70, 189),
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
           color: Color.fromARGB(255, 6, 70, 189),
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Dev Zenify",
      ),
    );
  }

  Widget adddres() {
    return TextFormField(
      controller: _adddres,
      validator: (value) {
        if (value!.isEmpty) return "adddres can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
           color: Color.fromARGB(255, 6, 70, 189),
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.add_home_work_sharp,
           color: Color.fromARGB(255, 6, 70, 189),
        ),
        labelText: "adddres",
        helperText: "adddres can't be empty",
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
           color: Color.fromARGB(255, 6, 70, 189),
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
           color: Color.fromARGB(255, 6, 70, 189),
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
           color: Color.fromARGB(255, 6, 70, 189),
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color:   Color.fromARGB(255, 6, 70, 189),
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: zipCode,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
           color: Color.fromARGB(255, 6, 70, 189),
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        labelText: "About",
        helperText: "Write about yourself",
        hintText: "I am Dev Stack",
      ),
    );
  }
}
