import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.obscureText
});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 20
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(
          icon, color: Colors.white.withOpacity(0.3)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none
        ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.green)
          ),
        hintText: hintText
      ),
    );
  }
}