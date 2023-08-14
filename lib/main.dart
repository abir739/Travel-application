import 'package:flutter/material.dart';
import 'package:zenify_trip/register.dart';
import 'package:get/get.dart';

import 'login.dart';


void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MyLogin(),
    routes: {
      'register': (context) => const MyRegister(),
      'login': (context) => const MyLogin(),
    },
  ));
}
