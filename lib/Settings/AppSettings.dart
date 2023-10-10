import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLoader {
  static const String keyTheme = 'themeKey';
  static const String keyHideEmptyScheduleWeek = 'hideEmptyScheduleWeekKey';
  static const String keyAnimation = 'animationKey';
static const String keyBackgroundImage = 'backgroundImageKey'; // New key
  // Save theme setting
  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyTheme, isDarkMode);
  }
  // Save background image setting
  static Future<void> saveBackgroundImage(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyBackgroundImage, imagePath ?? '');
  }

  // Load background image setting
static Future<String?> loadBackgroundImage() async {
  final prefs = await SharedPreferences.getInstance();
  final imagePath = prefs.getString(keyBackgroundImage);
  print('Loaded background image path: $imagePath');
   return prefs.getString(keyBackgroundImage) ?? null;

}
  // Load theme setting
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTheme) ?? false; // Default value is false
  }

  // Save hideEmptyScheduleWeek setting
  static Future<void> saveHideEmptyScheduleWeek(bool hide) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyHideEmptyScheduleWeek, hide);
  }

  // Load hideEmptyScheduleWeek setting
  static Future<bool> loadHideEmptyScheduleWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyHideEmptyScheduleWeek) ?? false; // Default value is false
  }

  // Save animation setting
  static Future<void> saveAnimation(bool isAnimated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAnimation, isAnimated);
  }

  // Load animation setting
  static Future<bool> loadAnimation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAnimation) ?? false; // Default value is false
  }
}
