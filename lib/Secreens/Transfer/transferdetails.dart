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
import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../../../modele/activitsmodel/activityTempModel.dart';
import '../../HTTPHandlerObject.dart';
import '../../constent.dart';
import '../../modele/Event/Event.dart';
import '../../modele/activitsmodel/httpActivitesTempid.dart';

import 'TransportEditDetails.dart';

class TransportSecreen extends StatefulWidget {
  Transport? transport;
  String? token;

  TransportSecreen(this.transport, this.token, {Key? key})
      : super(key: key);

  @override
  _TransportSecreenState createState() =>
      _TransportSecreenState();
}

class _TransportSecreenState extends State<TransportSecreen> {
  HTTPHandler trasferhandler = HTTPHandler();
  late Transport transport;
  String? baseUrl = "";
  String token = "";
  bool isLoading = true;
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;
  Future<Transport> _loadData() async {
    // String? accessToken = await getAccessToken();
    print('${widget.token} token');
    final updatedData = await trasferhandler.fetchData(
        "/api/transfers/${widget.transport!.id}",Transport.fromJson);
    setState(() {
      transport = updatedData;

      print(updatedData.id);
      isLoading = false;
    });
    return updatedData;
  }

  final storage = const FlutterSecureStorage();
  late Transport _transport;
  ImageProvider? image;
  Future<String?> getAccessToken() async {
    final token = await storage.read(key: 'access_token');
    return token;
  }

  @override
  void initState() {
    super.initState();

    // getAccessToken();
    _transport = widget.transport!;
    _loadData();
    print('tokensss ${widget.token.toString()}');
  
  }



  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _refresh() async {
    print("Screen refreshed");
    setState(() {
      _transport = Transport(
        id: _transport.note,
        driverId: "New name",
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
        title: Text("transport Detail"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport.note ?? "No name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    HtmlWidget(
                      transport.id ?? "No description",
                    ),
                    // Add more widgets to display other properties of 'activites'
ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransportEditDetails(
                              transport,
                              token,
                            ),
                          ),
                        );
                      },
                      child: Text("Edit Transport Details"),
                    ),

                  ],
                ),
              ),
            ),
    );
  }
}
