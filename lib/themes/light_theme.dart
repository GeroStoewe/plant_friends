import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

ThemeData lightTheme(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double textScaleFactor = size.width / 400;

  return ThemeData(
    brightness: Brightness.light,
    primaryColor: seaGreen,
    hintColor: darkSeaGreen,
    focusColor: seaGreen,
    scaffoldBackgroundColor: lightBG,
    textTheme: TextTheme(
      bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 14 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200
      ),
      bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16 * textScaleFactor,
          fontFamily: 'Poppins',
      ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 20 * textScaleFactor,
          fontFamily: 'Poppins',
        ),
      headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 26 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
      ),
      headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 22 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
      ),
      labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 24 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
      labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 24 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
      labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 18 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400
      ),
      displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 20 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300
      ),
        displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 16 * textScaleFactor,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.italic
        ),
      displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 20 * textScaleFactor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: darkSeaGreen,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: forestGreen,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkGreyGreen,
    ),
  );
}
