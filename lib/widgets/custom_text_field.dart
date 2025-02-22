import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.obscureText,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size; // Get screen size
    double textScaleFactor = size.width / 400; // Responsive font size factor

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 18 * textScaleFactor, // Make font size responsive
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        prefixIcon: Icon(
          icon,
          size: 18 * textScaleFactor,
          color: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18 * textScaleFactor, // Make hint text size responsive
          color: isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: 14 * textScaleFactor, // Make vertical padding responsive
          horizontal: 10 * textScaleFactor, // Make horizontal padding responsive
        ),
      ),
    );
  }
}
