import 'package:flutter/material.dart';

class CustomNumberField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  CustomNumberField({
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

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      onChanged: (value) {
        // Validate input
        int? intValue = int.tryParse(value);
        if (intValue != null && (intValue < 1 || intValue > 50)) {
          // If value is out of range, clear the field or provide feedback
          controller.text = ''; // Clear the field or use other feedback
          // Optionally show a SnackBar or a dialog to notify the user
        }
      },
    );
  }
}
