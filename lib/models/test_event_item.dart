import 'package:flutter/material.dart';
import 'package:plant_friends/models/test_calendar_event.dart';

class EventItem extends StatelessWidget {
  final CalendarEvent event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio<bool>(
        value: true,
        groupValue: event.isDone,
        onChanged: (bool? value) {
          // Handle radio button change if needed
        },
      ),
      title: Text(
        event.title,
      ),
      subtitle: Text(
        event.description,
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
