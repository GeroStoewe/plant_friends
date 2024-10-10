import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'calendar_event.dart';

class EventItem extends StatefulWidget {
  final CalendarEvent event;
  final Function()? onTap;
  final Function() onStatusChanged;  // New callback function to reload events

  const EventItem({
    Key? key,
    required this.event,
    this.onTap,
    required this.onStatusChanged,  // Pass the callback
  }) : super(key: key);

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  void _toggleIsDone() async {
    // Update the isDone status in Firestore
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({'isDone': !widget.event.isDone});

    // Trigger the refresh callback after updating
    widget.onStatusChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0), // Padding around the large icon
          child: widget.event.eventType == 'Watering'
              ? const Icon(Icons.water_drop, size: 30.0, color: Colors.blue)
              : widget.event.eventType == 'Fertilizing'
              ? const Icon(Icons.local_florist, size: 30.0, color: Colors.green)
              : const SizedBox.shrink(), // If no event type matches
        ),
        title: Text(widget.event.plantName),
        subtitle: Text(widget.event.eventType),
        trailing: Container(
          padding: const EdgeInsets.all(0.5), // Padding around the icon
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular shape
            border: Border.all(
              color: Colors.grey, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: IconButton(
            icon: Icon(
              widget.event.isDone ? Icons.check : Icons.close,
              color: widget.event.isDone ? Colors.green : Colors.red,
            ),
            onPressed: _toggleIsDone,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}