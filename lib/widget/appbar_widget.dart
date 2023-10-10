import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenify_trip/routes/themeprovider.dart';
import 'package:zenify_trip/theme.dart';

AppBar buildAppBar(BuildContext context) {
  final themeModel = Provider.of<ThemeModelp>(context);
  final isDarkMode = themeModel.isDarkMode;
  final icon = isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars;

  return AppBar(
  
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon),
        onPressed: () {
          themeModel.toggleTheme(); // Toggle the theme using the ThemeModel
        },
      ),
    ],
  );
}

 
 
