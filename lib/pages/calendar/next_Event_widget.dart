import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';

// Custom widget for displaying event details
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        subtitle: Text('Date: $formattedDate', style: const TextStyle(fontSize: 16)),
        contentPadding: const EdgeInsets.all(16),
        tileColor: seaGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
