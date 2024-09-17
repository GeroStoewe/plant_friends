import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/models/test_calendar_event.dart';

class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final CalendarEvent event;
  const EditEvent({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    required this.event,
  }) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _isDone; // Add this property

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _isDone = widget.event.isDone; // Initialize _isDone
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          CheckboxListTile(
            title: const Text("Done"),
            value: _isDone,
            onChanged: (bool? value) {
              setState(() {
                _isDone = value ?? false;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('Title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDate),
      "isDone": _isDone, // Update the isDone field
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
