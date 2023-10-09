import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_trip/services/constent.dart';
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';
import 'package:intl/intl.dart';

import '../../HTTPHandlerObject.dart'; // For date formatting


class TransportEditDetails extends StatefulWidget {
  Transport? transport;
  String? token;

  TransportEditDetails(this.transport, this.token, {Key? key})
      : super(key: key);

  @override
  _TransportEditDetailsState createState() => _TransportEditDetailsState();
}

class _TransportEditDetailsState extends State<TransportEditDetails> {
  late Transport transport;
  String? baseUrl = "";
  String? token = "";
  bool isLoading = true;
  TextEditingController messageController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  late Future<void> _initializeVideoPlayerFuture;
  HTTPHandler trasferhandler = HTTPHandler();
bool sendNotification = false;
  Map<String, dynamic>? updatedData = {}; // Updated data for transport

  Future<Transport> _loadData() async {
    // Load transport data and initialize updatedData
    final updatedData = await trasferhandler
        .fetchData("/api/transfers/${widget.transport!.id}",Transport.fromJson);
    setState(() {
      transport = updatedData;
      isLoading = false;
    });
    return updatedData;
  }

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    titleController.dispose();
    typeController.dispose();
  }

  Future<void> updateTransportData(
      String? id, Map<String, dynamic> data) async {
     token = await storage.read(key: 'access_token');
    // Make your API call to update the transport data
    // Example using http package:
    final additionalData = {
      "message": messageController.text,
      "title": titleController.text,
      "type": typeController.text,"sendNotification":sendNotification
    };

    // Merge the additional data with the existing data
    data.addAll(additionalData);
    final response = await http.patch(
      Uri.parse("$baseUrls/api/transfers/$id"),
      headers: {
        "Authorization":
            "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      // Transport data updated successfully
      // Handle the response as needed
      print("Transport data updated");
      print(updatedData);
    } else {
      // Error updating transport data
      // Handle the error response
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Error updating transport data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transport Details"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport.note ?? "No name",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    HtmlWidget(
                      transport.id ?? "No description",
                    ),
                    // Display other properties of 'activites'

                    // Dynamically generated update fields
                    Column(
                      children: transport.toJson().entries.map((entry) {
                        final field = entry.key ?? "";
                        final value = entry.value ?? "";
                        if (field == "id") {
                          return Text(
                              "$field: $value"); // Display id as non-editable text
                        }
                        if (field == "date") {
                          return InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(value),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  updatedData![field] =
                                      selectedDate.toIso8601String();
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: field,
                                hintText: "Select a date",
                              ),
                              child: Text(DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(value))),
                            ),
                          );
                        }
                        return TextFormField(
                          initialValue: value.toString(),
                          onChanged: (newValue) {
                            setState(() {
                              updatedData![field] = newValue;
                            });
                          },
                          decoration: InputDecoration(labelText: field),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(labelText: "Message"),
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextFormField(
                      controller: typeController,
                      decoration: const InputDecoration(labelText: "Type"),
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.notification_add,
                            color: Colors.amber,
                          ),
                          const Text('Send notification',
                              style: TextStyle(
                                  color: Colors.black12,
                                  fontWeight: FontWeight.w600)),
                          CupertinoSwitch(
                              value: sendNotification,
                              onChanged: (val) {
                                setState(() {
                                  sendNotification = val;
                                  print(sendNotification.toString());
                                });
                              }),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (updatedData != null) {
                          // Call the updateTransportData function with the updatedData
                          updateTransportData(transport.id, updatedData!);
                         
                        }
                      },
                      child: const Text("Update Transport Data"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
