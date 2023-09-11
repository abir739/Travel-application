
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'dart:async';
import 'package:video_player/video_player.dart';

import 'package:zenify_trip/modele/transportmodel/transportModel.dart';

import '../../HTTPHandlerObject.dart';

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
      const SnackBar(content: Text('Screen refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("transport Detail"),
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
                      child: const Text("Edit Transport Details"),
                    ),

                  ],
                ),
              ),
            ),
    );
  }
}
