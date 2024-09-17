import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;

  const AddEvent({
    Key? key,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _intervalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Events")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Start Date: ${widget.firstDate.toLocal().toIso8601String()}'),
          Text('End Date: ${widget.lastDate.toLocal().toIso8601String()}'),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Event Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Event Description'),
          ),
          TextField(
            controller: _intervalController,
            decoration: const InputDecoration(labelText: 'Interval (days)'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              _createEvents();
            },
            child: const Text("Create Events"),
          ),
        ],
      ),
    );
  }

  Future<void> _createEvents() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final intervalStr = _intervalController.text;

    try {
      final intervalDays = int.parse(intervalStr);

      await _createEventsInRange(widget.firstDate, widget.lastDate, intervalDays, title, description);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle errors (e.g., invalid input format)
      print('Error: $e');
    }
  }

  Future<void> _createEventsInRange(DateTime startDate, DateTime endDate, int intervalDays, String title, String description) async {
    final firestore = FirebaseFirestore.instance;
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      final event = {
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(currentDate),
      };

      await firestore.collection('events').add(event);

      // Move to the next event date
      currentDate = currentDate.add(Duration(days: intervalDays));
    }
  }
}
