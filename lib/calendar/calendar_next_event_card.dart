import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

class EventCardNextDate extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime? date;

  const EventCardNextDate({
    Key? key,
    required this.icon,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = date != null ? DateFormat('dd/MM/yyyy').format(date!) : 'N/A';
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
            size: 25,
            color: seaGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: seaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: seaGreen,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
