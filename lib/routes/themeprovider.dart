import 'package:flutter/cupertino.dart';

class ThemeModelp extends ChangeNotifier {
  bool _isDarkMode = true; // Set an initial theme

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
