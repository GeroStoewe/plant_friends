import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_friends/laurasTestFolder/test_calendar_event.dart';

class EventItemTest extends StatefulWidget {
  final CalendarEventTest event;
  final Function()? onTap;
  final Function() onStatusChanged;  // New callback function to reload events

  const EventItemTest({
    Key? key,
    required this.event,
    this.onTap,
    required this.onStatusChanged,  // Pass the callback
  }) : super(key: key);

  @override
  _EventItemTestState createState() => _EventItemTestState();
}

class _EventItemTestState extends State<EventItemTest> {
  void _toggleIsDone() async {
    // Update the isDone status in Firestore<
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({'isDone': !widget.event.isDone});

    // Trigger the refresh callback after updating
    widget.onStatusChanged();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          widget.event.isDone ? Icons.check : Icons.close,
          color: widget.event.isDone ? Colors.green : Colors.red,
        ),
        onPressed: _toggleIsDone,
      ),
      title: Row(
        children: [
          if (widget.event.eventType == 'Watering')
            const Icon(Icons.water_drop, color: Colors.blue),
          if (widget.event.eventType == 'Fertilizing')
            const Icon(Icons.local_florist, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            widget.event.plantName,
          ),
        ],
      ),
      subtitle: Text(widget.event.eventType),
      onTap: widget.onTap,

    );
  }
}
