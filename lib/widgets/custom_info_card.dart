import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart'; // Assuming lmCardBG and dmCardBG are defined here

class CustomInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const CustomInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? dmCardBG : lmCardBG, // Background color based on theme
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: seaGreen,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: seaGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: seaGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}