import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_friends/themes/colors.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_event.dart';
import 'calendar_event_item.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<CalendarEvent>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
        fromFirestore: CalendarEvent.fromFirestore,
        toFirestore: (event, options) => event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
      DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }


  List<CalendarEvent> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar App')),
      body: ListView(
        children: [
          TableCalendar(
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,

            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: darkSeaGreen,
              ),
              selectedDecoration: BoxDecoration(
                color: seaGreen, // Hintergrundfarbe für den ausgewählten Tag
                shape: BoxShape.circle, // Die Form des Hintergrunds
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white, // Textfarbe für den ausgewählten Tag
              ),
              todayDecoration: BoxDecoration(
                color: darkSeaGreen, // Hintergrundfarbe für den heutigen Tag
                shape: BoxShape.circle, // Die Form des Hintergrunds
              ),
              todayTextStyle: TextStyle(
                color: Colors.white, // Textfarbe für den heutigen Tag
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final headerDateFormat = DateFormat('MMMM yyyy'); // Format für den Monat und das Jahr
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    headerDateFormat.format(day),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          _getEventsForTheDay(_selectedDay).isEmpty
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "All your plants are happy. \nThere is nothing for you to do on this day.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16), // Space between text and icon
                Icon(
                  Icons.sunny,
                  size: 40,
                  color: Colors.yellow, // Color for the icon
                ),
              ],
            ),
          )
              : Column(
            children: _getEventsForTheDay(_selectedDay)
                .map((event) => EventItem(
              event: event,
              onStatusChanged: _loadFirestoreEvents, // Pass the refresh callback
            ))
                .toList(),
          ),

        ],
      ),
    );
  }

}
