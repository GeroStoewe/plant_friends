import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.obscureText
});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
        prefixIcon: Icon(
            icon,
            color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none
        ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Theme.of(context).focusColor)
          ),
        hintText: hintText
      ),
    );
  }
}