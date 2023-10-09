
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';
import 'package:zenify_trip/login/login_Page.dart';
import '../../services/constent.dart';

class FilePickerUploader {
  Future<String?> pickAndUploadFile({
    required String dynamicPath,
    required String id,
    required String object,
    required String field,
  }) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.image);

    if (result != null) {
      for (PlatformFile file in result.files) {
        print('File picked: ${file.name}');
        String filePath = file.path!;
        File image = File(filePath);
        String? uploadedFileName = await uploadFile(
          file: image,
          dynamicPath: dynamicPath,
          object: object,id:id,
          field: field,
        );
        print('File uploaded successfully!');

        if (uploadedFileName != null) {
          return uploadedFileName;
        }
      }
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }

    return null; // Return null if no file was uploaded
  }

  Future<String?> uploadFile({
    required File file,
    required String dynamicPath,
    required String object,
    required String id,
    required String field,
  }) async {
    // Get the access token and baseUrl
    String? token = await storage.read(key: "access_token");

    try {
      // Create the multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrls}/api/filer/upload'),
      );

      // Set the authorization header
      request.headers.addAll({'Authorization': 'Bearer $token'});

      // Add the dynamic 'path' parameter to the request body
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
          print(object);
          print('$id api/users');
          print(baseUrls);
          // Now you can proceed with the PATCH request to update the image field
          await updateImageField(fileName, object, id, field);
          return fileName; // Return the uploaded file name
        }
      } else {
        print('Error uploading files : ${uploadResponse.statusCode}');
        throw Exception('Error uploading files : ${uploadResponse.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> updateImageField(
    String fileName,
    String object,
    String id,
    String field,
  ) async {
    // Get the access token and baseUrl
    String? token = await storage.read(key: "access_token");

    try {
      final String apiUrl = '${baseUrls}/$object/$id';

      // Make the PATCH request to update the image field
      final logoUpdateResponse = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {field: fileName}, // Use the extracted file name here
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
}
