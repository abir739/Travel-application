import 'package:flutter/foundation.dart';

class NotificationCountNotifier with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {

    _count++;
    notifyListeners();
    print('Count incremented: $_count');
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
