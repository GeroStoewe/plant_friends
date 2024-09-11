import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  
  const SquareTile({
    super.key,
    required this.imagePath
  });
  
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? dmDarkGrey : lmLightGrey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(imagePath, width: 40),
    );
  }
}