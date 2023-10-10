import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:zenify_trip/Settings/AppSettings.dart';
import 'package:zenify_trip/Settings/SettingModel.dart';


class SettingsProvider extends ChangeNotifier {
  late AppSettings _settings;
  late bool _hideEmptyScheduleWeek;
  late bool _isDarkMode;
  late bool _isAnimated;
String? _backgroundImage;

  SettingsProvider() {
    _settings = AppSettings(enableCustomTheme: true);
    _hideEmptyScheduleWeek = false; // Initialize to false by default
    _isDarkMode = false; // Initialize to false by default
    _isAnimated = false; // Initialize to false by default
    loadSettings();
  }

  AppSettings get settings => _settings;
String? get backgroundImage => _backgroundImage;

  bool get hideEmptyScheduleWeek => _hideEmptyScheduleWeek;

  void set hideEmptyScheduleWeek(bool value) {
    _hideEmptyScheduleWeek = value;
    notifyListeners();
  }

void setBackgroundImage(String? imagePath) {
  _backgroundImage = imagePath;
  notifyListeners();
}
  bool get isDarkMode => _isDarkMode;

  bool get isAnimated => _isAnimated;
set backgroundImage(String? value) {
  _backgroundImage = value;
  notifyListeners();
}
  void updateSettings(AppSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  void setHideEmptyScheduleWeek(bool value) {
    _hideEmptyScheduleWeek = value;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void toggleAnimation() {
    _isAnimated = !_isAnimated;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future<void> loadSettings() async {
    _isDarkMode = await AppSettingsLoader.loadTheme();
    _hideEmptyScheduleWeek = await AppSettingsLoader.loadHideEmptyScheduleWeek();
    _isAnimated = await AppSettingsLoader.loadAnimation();
    _backgroundImage = await AppSettingsLoader.loadBackgroundImage();
    notifyListeners(); // Notify listeners that settings have been loaded
  }
}
