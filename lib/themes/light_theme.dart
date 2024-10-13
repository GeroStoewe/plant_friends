import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: seaGreen,
    hintColor: darkSeaGreen,
    focusColor: seaGreen,
    scaffoldBackgroundColor: lightBG,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200
      ),
      bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Poppins',
      ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
        ),
      headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
      ),
      headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
      ),
      labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
      labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
      labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400
      ),
      displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300
      ),
        displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.italic
        ),
      displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
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
