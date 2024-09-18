import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: seaGreen,
    hintColor: lightSeaGreen,
    focusColor: seaGreen,
    scaffoldBackgroundColor: darkBG,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
          color: Colors.white,
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
      displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400
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
