import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart'; // Assuming lmCardBG and dmCardBG are defined here

import 'package:auto_size_text/auto_size_text.dart';
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
          Expanded( // Use Expanded to avoid overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  title,
                  style: TextStyle(
                    color: seaGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Limit to one line and shrink if needed
                  minFontSize: 12, // Minimum font size
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  value,
                  style: TextStyle(
                    color: seaGreen,
                  ),
                  maxLines: 1, // Limit to one line and shrink if needed
                  minFontSize: 12, // Minimum font size
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
