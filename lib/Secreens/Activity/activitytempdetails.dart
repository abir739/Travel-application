import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:stream_transform/stream_transform.dart';

import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/modele/activitsmodel/activitesmodel.dart';

import '../../../modele/activitsmodel/activityTempModel.dart';
import '../../constent.dart';
import '../../modele/Event/Event.dart';
import '../../modele/activitsmodel/httpActivitesTempid.dart';

class activitytempdetalSecreen extends StatefulWidget {
  Activity? activity;
  String? token;

  activitytempdetalSecreen(this.activity, this.token, {Key? key})
      : super(key: key);

  @override
  _activitytempdetalSecreenState createState() =>
      _activitytempdetalSecreenState();
}

class _activitytempdetalSecreenState extends State<activitytempdetalSecreen> {
  HTTPHandlerActivitestempId activiteshanhler = HTTPHandlerActivitestempId();
  late ActivityTemplate activites;
  String? baseUrl = "";
  String token = "";
  bool isLoading = true;
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;
  Future<ActivityTemplate> _loadData() async {
    // String? accessToken = await getAccessToken();
    print('${widget.token} token');
    final updatedData = await activiteshanhler.fetchData(
        "/api/activity-templates/${widget.activity!.activityTemplateId}");
    setState(() {
      activites = updatedData;

      print(updatedData.id);
      isLoading = false;
    });
    return updatedData;
  }

  final storage = const FlutterSecureStorage();
  late Activity _activity;
  ImageProvider? image;
  Future<String?> getAccessToken() async {
    final token = await storage.read(key: 'access_token');
    return token;
  }

  @override
  void initState() {
    super.initState();

    // getAccessToken();
    _activity = widget.activity!;
    _loadData();
    print('tokensss ${widget.token.toString()}');
    // _getTokenAndInitializePlayer();
    // _controller = VideoPlayerController.network(
    //   '${widget.bs}/api/activity-templates/uploads/${widget.activity!.video}',
    //   // 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4',
    //   httpHeaders: {
    //     'Authorization': 'Bearer ${widget.token}',
    //   },
    // )..initialize().then((_) {
    //     setState(() {});
    //   }).catchError((error) {
    //     print('Video player initialization failed: $error');
    //   });
    // _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.setLooping(true);
    // _controller.setVolume(1.0);
  }

  // Future<void> _getTokenAndInitializePlayer() async {

  //   String? bs = await storage.read(key: 'baseurl');
  //   if (widget.token != null && bs != null) {
  //     // String bs = await storage.read(key: 'baseurl');print('$tokens tokens');
  //     print('${widget.activity!.activityTemplateId} videoo');
  //     _controller = VideoPlayerController.network(
  //       '${baseUrls}/api/activity-templates/uploads/${widget.activity!.activityTemplate!.video}',
  //       httpHeaders: {'Authorization': 'Bearer ${widget.token}'},
  //     )..initialize().then((_) {
  //         setState(() {});
  //       }).catchError((error) {
  //         print('Video player initialization failed: $error');
  //       });
  //     _initializeVideoPlayerFuture = _controller.initialize();
  //     _controller.setLooping(true);
  //     _controller.setVolume(1.0);
  //   } else {
  //     print('Error: access_token not found in storage');
  //   }
  // }

  // Future<void> uploadFile(File file, String? activityTempId) async {
  //   // Get the access token

  //   // Create the multipart request
  //   var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           '${baseUrls}/api/activity-templates/uploadvideo/${activityTempId}'));

  //   // Set the authorization header
  //   request.headers.addAll({'Authorization': 'Bearer ${widget.token}'});

  //   // Add the file to the request
  //   var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  //   var length = await file.length();
  //   var multipartFile = new http.MultipartFile('file', stream, length,
  //       filename: path.basename(file.path));
  //   request.files.add(multipartFile);

  //   // Send the request
  //   var response = await request.send();

  //   // Check the response status code
  //   if (response.statusCode == 200) {
  //     print('File uploaded successfully!');
  //   } else {
  //     print('Error uploading file: ${response.statusCode}');
  //   }
  // }

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
  // Future<void> pickFile() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);

  //   if (result != null) {
  //     for (PlatformFile file in result.files) {
  //       print('File picked: ${file.name}');
  //       String filePath = file.path!;
  //       setState(() {
  //         image = FileImage(File(filePath));
  //       });
  //       await uploadFile(File(filePath), widget.activity!.id);
  //       final snackBar = SnackBar(
  //         /// need to set following properties for best effect of awesome_snackbar_content
  //         elevation: 0,
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.transparent,
  //         content: AwesomeSnackbarContent(
  //           title: ' Activitytemp   success',
  //           message: '',

  //           /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
  //           contentType: ContentType.success,
  //         ),
  //       );
  //       ScaffoldMessenger.of(context)
  //         ..hideCurrentSnackBar()
  //         ..showSnackBar(snackBar);
  //       // Close the AddActivity page and navigate back to the previous page
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => AddActivityTempScreen()),
  //       );
  //     }
  //   } else {
  //     // User canceled the picker
  //     print('User canceled the picker');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _refresh() async {
    print("Screen refreshed");
    setState(() {
      _activity = Activity(
        id: _activity.activityTemplateId,
        name: "New name",
        // update other properties as needed
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screen refreshed')),
    );
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Detail"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :   SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activites.name ?? "No name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      HtmlWidget(
                        activites.longDescription ?? "No description",
                      ),
                      // Add more widgets to display other properties of 'activites'
                    ],
                  ),
                ),
              ),
        
    );
  }
}
