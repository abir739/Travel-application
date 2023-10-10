import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenify_trip/Settings/AppSettings.dart';
import 'package:zenify_trip/login/login_Page.dart';
import 'package:zenify_trip/routes/SettingsProvider.dart';
import 'package:zenify_trip/routes/themeprovider.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'dart:io'; // Import File class

class SettingsScreen extends StatelessWidget {
  @override
  Future<void> logout() async {
    // Delete sensitive data from secure storage
    await storage.deleteAll();

    // Clear data associated with the private screen (if applicable)
    // Example: clear private screen-related variables or state
    // ...

    // Navigate to the login screen
    Get.offNamed('login');
  }

  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModelp>(context);
    final settingsProvider =
        Provider.of<SettingsProvider>(context); // Use the correct variable name

    final isDarkMode = settingsProvider.isDarkMode;
    final ishide = settingsProvider
        .hideEmptyScheduleWeek; // Access the hideEmptyScheduleWeek property
    final animation = settingsProvider
        .isAnimated; // Access the hideEmptyScheduleWeek property

    final icon =
        isDarkMode ? CupertinoIcons.moon_stars : CupertinoIcons.sun_max;
    final iconhedin = ishide ? CupertinoIcons.eye : CupertinoIcons.lock_shield;
    final iconanimation =
        animation ? CupertinoIcons.play : CupertinoIcons.stopwatch;

    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
                onPressed: (context) {
                  // Add your navigation logic here
                },
              ),
              SettingsTile.switchTile(
                leading: Icon(icon),
                title: const Text('Enable custom theme'),
                onToggle: (value) {
                  settingsProvider.toggleTheme(); // Toggle the theme
                  AppSettingsLoader.saveTheme(!isDarkMode);
                },
                activeSwitchColor: const Color.fromARGB(255, 1, 112, 185),
                initialValue: !isDarkMode,
              ),
              SettingsTile.switchTile(
                leading: Icon(iconhedin),
                title: const Text('hideEmptyScheduleWeek'),
                onToggle: (value) {
                  settingsProvider.setHideEmptyScheduleWeek(
                      value); // Toggle the hideEmptyScheduleWeek setting
                  AppSettingsLoader.saveHideEmptyScheduleWeek(!ishide);
                },
                activeSwitchColor: const Color.fromARGB(255, 1, 112, 185),
                initialValue: ishide,
              ),
              SettingsTile.switchTile(
                leading: Icon(iconanimation),
                title: const Text('animated Pick'),
                onToggle: (value) {
                  settingsProvider
                      .toggleAnimation(); // Toggle the hideEmptyScheduleWeek setting
                  AppSettingsLoader.saveAnimation(!animation);
                },
                activeSwitchColor: const Color.fromARGB(255, 1, 112, 185),
                initialValue: animation,
              ),
              SettingsTile.navigation(
                leading: const Icon(CupertinoIcons.graph_square_fill),
                title: const Text('Choose your background menu'),
                // onPressed: (BuildContext context) async {
                // final status = await Permission.photos.request();
                // if (status.isGranted) {
                //   final imagePicker = ImagePicker();
                //   final pickedImage = await imagePicker.pickImage(source:  image_picker.ImageSource.gallery);
                //   if (pickedImage != null) {
                //     // Handle the picked image (File)
                //     File pickedFile = File(pickedImage.path);
                //     // You can now use 'pickedFile' as your background image
                //     // Example: _backgroundImage = pickedFile;
                //   }
                // }else if (status.isDenied) {
                //   // Permission denied, explain why you need it and provide a way to grant it manually
                //   await openAppSettings(); // Opens the app's settings where the user can manually enable the permission
                // }  else {
                //   // Handle permissions denied
                // }}
  onPressed: (BuildContext context) async {
  
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the picked file
      PlatformFile file = result.files.first;
      File pickedFile = File(file.path!);
 final settingsProvider =
            Provider.of<SettingsProvider>(context, listen: false);
 settingsProvider.setBackgroundImage(pickedFile.path);

        // Save the background image path using AppSettingsLoader
        AppSettingsLoader.saveBackgroundImage(pickedFile.path);
      // Handle the picked image (File)
      // Example: _backgroundImage = pickedFile;
    }
  else {
    // Handle permissions denied here, e.g., show a dialog or a message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('You have denied permission to access photos. Please grant the necessary permissions in your device settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
},
                
              ),
              SettingsTile.navigation(
                leading: const Icon(CupertinoIcons.arrow_left_to_line_alt),
                title: const Text('logout'),
                onPressed: (value) {
                  logout();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
