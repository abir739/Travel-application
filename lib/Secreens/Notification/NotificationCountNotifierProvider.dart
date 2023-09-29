import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationCountNotifier with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
    Get.snackbar('new notification Have Ben', "",
        colorText: Colors.white,
        backgroundColor: Color.fromARGB(52, 243, 199, 3));
    print('Count incremented: $_count');
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
