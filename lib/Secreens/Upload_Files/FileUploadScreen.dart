import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'package:stream_transform/stream_transform.dart';

import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

import '../../constent.dart';
import '../../login.dart';
import 'package:get/get.dart';
class FileUploadScreen extends StatefulWidget {
  @override
  final String dynamicPath;
  final String id;
  final String fild;
  final String object;
  FileUploadScreen(
      {required this.dynamicPath,
      required this.fild,
      required this.id,
      required this.object}); // Constructor to receive the dynamic path
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? image;

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (PlatformFile file in result.files) {
        print('File picked: ${file.name}');
        String filePath = file.path!;
        setState(() {
          image = File(filePath);
        });
        await uploadFile(File(filePath));
        print('File uploaded successfully!');
        // Close the current page and navigate back to the previous page
        final newData =
            "Data from FileUploadScreen"; // Replace with actual data
 Get.back(result: newData);
      }
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }

  Future<void> uploadFile(File file) async {
    // Get the access token and baseUrl
    String? token = await storage.read(key: "access_token");

    // final String apiUrl =
    //     '${baseUrls}/api/activity-templates/${widget.activity.activityTemplate!.id}';

    try {
      // Create the multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrls}/api/filer/upload'),
      );

      // Set the authorization header
      request.headers.addAll({'Authorization': 'Bearer $token'});

      // Add the dynamic 'path' parameter to the request body
      String dynamicPath = widget
          .dynamicPath; // Access the dynamic path from the widget property
      request.fields['path'] = dynamicPath;

      // Add the file to the request
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('files', stream, length,
          filename: path.basename(file.path));
      request.files.add(multipartFile);

      // Send the request
      var uploadResponse = await request.send();
      if (uploadResponse.statusCode == 201) {
        var responseBody = await uploadResponse.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        var message = jsonResponse['message'];
        var fileNames = jsonResponse['fileNames'];
        if (fileNames != null && fileNames.isNotEmpty) {
          var fileName = fileNames[0]; // Assuming the first file name
          print('File uploaded successfully! File Name: $fileName');
          print("${widget.object}");
          print("${widget.id} api/users");
          print("${baseUrls}");
          // Now you can proceed with the PATCH request to update the image field
          await updateImageField(fileName);
        }
      } else {
        print('Error uploading files : ${uploadResponse.statusCode}');
        throw Exception('Error uploading files : ${uploadResponse.statusCode}');
      }

      // Remaining code for response handling...
    } catch (e) {
      // Error handling...
    }
  }

  Future<void> updateImageField(String fileName) async {
    // Get the access token and baseUrl
    String? token = await storage.read(key: "access_token");
    // String? baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '${baseUrls}/${widget.object}/${widget.id}';

    try {
      print("${token} token");
      // Make the PATCH request to update the image field
      final logoUpdateResponse = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {"${widget.fild}": fileName}, // Use the extracted file name here
      );

      // Check the response status code for logo update
      if (logoUpdateResponse.statusCode == 200) {
        print('Logo updated successfully!');
      } else {
        print('Error updating logo: ${logoUpdateResponse.statusCode}');
      }
    } catch (e) {
      print('Error updating logo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) Image.file(image!), // Display the picked image
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick and Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}

// Note: Make sure to replace 'storage', 'baseUrls', and other necessary variables as per your application.
