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
      bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200
      ),
      bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold
      ),
      headlineSmall: TextStyle(
          color: Colors.white,
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
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400
        ),
      labelSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400
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
      ),
      displayLarge: TextStyle(
          color: Colors.white,
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
