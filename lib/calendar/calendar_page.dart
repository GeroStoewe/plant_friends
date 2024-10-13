import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
  late DateTime? _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<CalendarEvent>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
  String? _getUserId() {
    User? user = FirebaseAuth.instance.currentUser; // Get the currently logged-in user
    return user?.uid; // Return the userId (null if the user is not signed in)
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
    _selectedDay = null; // Set to null initially
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    String? currentUserId = _getUserId(); // Aktuelle UserID holen
    if (currentUserId == null) {
      // Wenn der Benutzer nicht angemeldet ist, keine Events laden
      return;
    }

    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: currentUserId) // Filter für die aktuelle UserID
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
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
            calendarStyle: CalendarStyle(
              weekendTextStyle: const TextStyle(
                color: darkSeaGreen,
              ),
              selectedDecoration: const BoxDecoration(
                color: seaGreen,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(
                  color: darkSeaGreen, // Farbe der Umrandung
                  width: 2, // Breite der Umrandung
                ),
                shape: BoxShape.circle,
                color: Colors.transparent, // Hintergrund transparent
              ),
              todayTextStyle: const TextStyle(
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final headerDateFormat = DateFormat('MMMM yyyy');
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    headerDateFormat.format(day),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _selectedDay == null
                ? const Padding(
              padding: EdgeInsets.all(45.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Please select a date to see the events.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 40,
                    color: seaGreen,
                  ),
                ],
              ),
            )
                : _getEventsForTheDay(_selectedDay!).isEmpty
                ? const Padding(
              padding: EdgeInsets.all(45.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "All your plants are happy. \nThere is nothing for you to do on this day.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Icon(
                    Icons.sunny,
                    size: 40,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
                : SingleChildScrollView(
              child: Column(
                children: _getEventsForTheDay(_selectedDay!)
                    .map((event) => EventItem(
                  event: event,
                  onStatusChanged: _loadFirestoreEvents,
                ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
