import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;

    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);

    notifyListeners();
  }
}
