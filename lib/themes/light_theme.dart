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
          fontSize: 28,
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
        )
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
