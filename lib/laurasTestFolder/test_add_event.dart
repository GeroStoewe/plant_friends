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
  final TextEditingController _intervalController = TextEditingController();
  final TextEditingController _plantIDController = TextEditingController();
  final TextEditingController _plantNameController = TextEditingController();

  String _eventType = 'Watering'; // Default event type

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
            controller: _plantIDController,
            decoration: const InputDecoration(labelText: 'Plant ID'),
          ),
          TextField(
            controller: _plantNameController,
            decoration: const InputDecoration(labelText: 'Plant Name'),
          ),
          TextField(
            controller: _intervalController,
            decoration: const InputDecoration(labelText: 'Interval (days)'),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: _eventType,
            onChanged: (String? newValue) {
              setState(() {
                _eventType = newValue!;
              });
            },
            items: <String>['Watering', 'Fertilizing']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
    final intervalStr = _intervalController.text;
    final plantID = _plantIDController.text;
    final plantName = _plantNameController.text;

    try {
      final intervalDays = int.parse(intervalStr);

      await _createEventsInRange(
        widget.firstDate,
        widget.lastDate,
        intervalDays,
        plantID,
        plantName,
        _eventType,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle errors (e.g., invalid input format)
      print('Error: $e');
    }
  }

  Future<void> _createEventsInRange(
      DateTime startDate,
      DateTime endDate,
      int intervalDays,
      String plantID,
      String plantName,
      String eventType,
      ) async {
    final firestore = FirebaseFirestore.instance;
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      final event = {
        'plantID': plantID,
        'plantName': plantName,
        'eventType': eventType,
        'isDone': false,
        'date': Timestamp.fromDate(currentDate),
      };

      await firestore.collection('events').add(event);

      // Move to the next event date
      currentDate = currentDate.add(Duration(days: intervalDays));
    }
  }
}
