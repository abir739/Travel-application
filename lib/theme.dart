import 'package:flutter/material.dart';
import 'modele/constants/colors.dart';

ThemeData kAppTheme = ThemeData(
    focusColor: kAccentColor,
    primaryColor: kPrimaryColor,
    highlightColor: kHighlightColor,
    scaffoldBackgroundColor: kPrimaryColor,
    buttonBarTheme: ButtonBarThemeData(
      buttonTextTheme:
          ButtonTextTheme.primary, // Replace with your desired text theme
    ),
   elevatedButtonTheme:ElevatedButtonThemeData(style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 152, 2, 152)),),), // Set the background color to blue
  
  appBarTheme: AppBarTheme(
        backgroundColor:
          AppPrimaryColor, // Make the AppBar background transparent
        elevation: 0, // Remove the shadow
      ),
    
   inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: TextStyle(color: kAccentColor),

      fillColor:Color.fromARGB(0, 90, 1, 1) ,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: kHighlightColor, // Change the color here
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: kAccentColor, // Change the color here
          width: 1.0,
        ),
      ),
          border: OutlineInputBorder( // Customize the border
            borderRadius: BorderRadius.circular(10.0), // You can adjust the radius

            borderSide: BorderSide(
              color:Color.fromARGB(0, 90, 1, 1) , // Set the border color
              width: 2.0, // Set the border width
            ),
          ),
        ),
      

    fontFamily: 'PlayFair',
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 34,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      headline3: TextStyle(
          color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
      headline4: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 13,
          fontFamily: 'PlayFair'),
      headline5: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      subtitle1: TextStyle(
        color: Color.fromARGB(255, 27, 2, 168),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      bodyText1: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 15,
          fontFamily: 'PlayFair',
          height: 1.4),
      caption: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'PlayFair'),
    ));
