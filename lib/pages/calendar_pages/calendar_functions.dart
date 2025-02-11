import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calendar_event_pages/calendar_event.dart';

class CalenderFunctions {

  Map<String, Map<String, int>> wateringIntervals = {
    'Low': {
      'Spring': 19,
      'Summer': 19,
      'Autumn': 26,
      'Winter': 28,
    },
    'Medium': {
      'Spring': 9,
      'Summer': 7,
      'Autumn': 9,
      'Winter': 12,
    },
    'High': {
      'Spring': 4,
      'Summer': 3,
      'Autumn': 5,
      'Winter': 7,
    },
  };

  String? _getUserId() {
    User? user = FirebaseAuth.instance.currentUser; // Get the currently logged-in user
    return user?.uid; // Return the userId (null if the user is not signed in)
  }

  Future<void> createNewEventsWatering(String? plantID, String plantName, String waterNeeds) async {
    DateTime firstDay = DateTime.now();
    DateTime lastDay = DateTime.now().add(const Duration(days: 180));
    String eventType = "Watering";

    try {
      await _createEventsInRangeWatering(firstDay, lastDay, plantID, plantName, eventType, waterNeeds);
    } catch (e) {
      // Handle errors (e.g., invalid input format)
      print('Error: $e');
    }

  }

  /*
  Future<void> createNewEventsFertilizing(String? plantID, String plantName, int dayInterval) async {
    DateTime firstDay = DateTime.now();
    DateTime lastDay = DateTime.now().add(const Duration(days: 365));
    String eventType = "Fertilizing";
    try {
      await _createEventsInRange(
        firstDay,
        lastDay,
        dayInterval,
        plantID,
        plantName,
        eventType,
      );
    } catch (e) {
      // Handle errors (e.g., invalid input format)
      print('Error: $e');
    }
  }
  */

  Future<void> createNewEventsWateringCustom(String? plantID, String plantName, int waterIntervall) async {
    wateringIntervals['Custom'] = {
      'Spring': waterIntervall,
      'Summer': waterIntervall,
      'Autumn': waterIntervall,
      'Winter': waterIntervall,
    };

    DateTime firstDay = DateTime.now();
    DateTime lastDay = DateTime.now().add(const Duration(days: 180));
    String eventType = "Watering";

    try {
      await _createEventsInRangeWatering(firstDay, lastDay, plantID, plantName, eventType, "Custom");
    } catch (e) {
      // Handle errors (e.g., invalid input format)
      print('Error: $e');
    }
  }


  Future<DateTime?> getNextWateringDate(String? plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String? userId = _getUserId(); // Aktuelle User-ID abrufen

    if (userId == null) {
      print('User is not logged in. Cannot fetch events.');
      return null;
    }

    try {
      // Adjust now to include today's date regardless of the current time
      DateTime today = DateTime(now.year, now.month, now.day);

      // Query Firestore for future watering events for the given plantID and userID
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .where('user_id', isEqualTo: userId) // Filter for the current user
          .where('eventType', isEqualTo: 'Watering')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first event's date
        Timestamp nextEventTimestamp = querySnapshot.docs.first['date'];
        return nextEventTimestamp.toDate();
      } else {
        // No future watering events found
        return null;
      }
    } catch (e) {
      print('Error fetching next watering date: $e');
      return null;
    }
  }

  Future<void> setTodaysWateringEventToDone(String? plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String? userId = _getUserId(); // Aktuelle User-ID abrufen

    if (userId == null) {
      print('User is not logged in. Cannot fetch events.');
      return;
    }

    try {
      // Heutiger Tagesbeginn und nächster Tag für Bereichssuche
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime tomorrowStart = todayStart.add(Duration(days: 1));

      print('Checking for watering event between $todayStart and $tomorrowStart');

      // Firestore-Abfrage nach Bewässerungsereignissen für heute
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .where('user_id', isEqualTo: userId)
          .where('eventType', isEqualTo: 'Watering')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('date', isLessThan: Timestamp.fromDate(tomorrowStart))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot eventDoc = querySnapshot.docs.first;
        print('Event found: ${eventDoc.id}, marking as done.');

        // Das heutige Ereignis als abgeschlossen markieren
        await firestore.collection('events').doc(eventDoc.id).update({
          'isDone': true,
        });

        print('Event successfully marked as done.');
      } else {
        print('No watering event found for today.');
      }
    } catch (e) {
      print('Error fetching or updating today\'s watering event: $e');
    }
  }


  Future<bool> checkIfTodaysWateringEventExists(String? plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String? userId = _getUserId();

    if (userId == null) {
      print('User is not logged in. Cannot fetch events.');
      return false;
    }

    try {
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime tomorrowStart = todayStart.add(Duration(days: 1));

      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .where('user_id', isEqualTo: userId)
          .where('eventType', isEqualTo: 'Watering')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('date', isLessThan: Timestamp.fromDate(tomorrowStart))
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking today\'s watering event: $e');
      return false;
    }
  }

  Future<bool> checkIfTodaysWateringEventNotDone(String? plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String? userId = _getUserId();

    if (userId == null) {
      print('User is not logged in. Cannot fetch events.');
      return false;
    }

    try {
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime tomorrowStart = todayStart.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .where('user_id', isEqualTo: userId)
          .where('eventType', isEqualTo: 'Watering')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('date', isLessThan: Timestamp.fromDate(tomorrowStart))
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      for (var doc in querySnapshot.docs) {
        var event = CalendarEvent.fromFirestore(doc);
        if (!event.isDone) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking today\'s watering event: $e');
      return false;
    }
  }





  /*
  Future<DateTime?> getNextFertilizingDate(String? plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String? userId = _getUserId(); // Aktuelle User-ID abrufen

    if (userId == null) {
      print('User is not logged in. Cannot fetch events.');
      return null;
    }

    try {
      // Adjust now to include today's date regardless of the current time
      DateTime today = DateTime(now.year, now.month, now.day);

      // Query Firestore for future fertilizing events for the given plantID and userID
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .where('user_id', isEqualTo: userId) // Filter for the current user
          .where('eventType', isEqualTo: 'Fertilizing')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first event's date
        Timestamp nextEventTimestamp = querySnapshot.docs.first['date'];
        return nextEventTimestamp.toDate();
      } else {
        // No future fertilizing events found
        return null;
      }
    } catch (e) {
      print('Error fetching next fertilizing date: $e');
      return null;
    }
  }



  Future<void> _createEventsInRangeFertilizing(
      DateTime startDate,
      DateTime endDate,
      int intervalDays,
      String? plantID,
      String plantName,
      String eventType,
      ) async {
    final firestore = FirebaseFirestore.instance;
    DateTime currentDate = startDate;
    String? userId = _getUserId(); // User-ID abrufen

    if (userId == null) {
      print('User is not logged in. Cannot create events.');
      return;
    }

    while (currentDate.isBefore(endDate)) {
      final event = {
        'plantID': plantID,
        'plantName': plantName,
        'eventType': eventType,
        'isDone': false,
        'user_id': userId, // Aktuelle User-ID speichern
        'date': Timestamp.fromDate(currentDate),
      };
      print("CREATE FERTILIZING EVENT: $event");

      //await firestore.collection('events').add(event);

      // Move to the next event date
      currentDate = currentDate.add(Duration(days: intervalDays));
    }
  }
  */


  Future<void> _createEventsInRangeWatering(
      DateTime startDate,
      DateTime endDate,
      String? plantID,
      String plantName,
      String eventType,
      String waterNeeds,
      ) async {
    final firestore = FirebaseFirestore.instance;
    DateTime currentDate = startDate;
    String? userId = _getUserId(); // User-ID abrufen

    if (userId == null) {
      print('User is not logged in. Cannot create events.');
      return;
    }

    while (currentDate.isBefore(endDate)) {
      // Determine the season for the current date
      String season = _getCurrentSeason(currentDate);

      // Determine the day interval based on water needs and season
      int dayInterval = wateringIntervals[waterNeeds]?[season] ?? 0;

      final event = {
        'plantID': plantID,
        'plantName': plantName,
        'eventType': eventType,
        'isDone': false,
        'user_id': userId, // Aktuelle User-ID speichern
        'date': Timestamp.fromDate(currentDate),
      };
      await firestore.collection('events').add(event);

      // Move to the next event date
      currentDate = currentDate.add(Duration(days: dayInterval));
    }
  }

  Future<void> deleteAllEventsForPlant(String plantID) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Query Firestore to get all events for the given plantID
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
          .get();

      // Loop through each document and delete it
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await firestore.collection('events').doc(doc.id).delete();
      }

      print('All events for plantID $plantID have been deleted.');
    } catch (e) {
      print('Error deleting events for plantID $plantID: $e');
    }
  }

  String _getCurrentSeason(DateTime date) {
    if ((date.month >= 3 && date.month <= 5)) {
      return 'Spring';
    } else if ((date.month >= 6 && date.month <= 8)) {
      return 'Summer';
    } else if ((date.month >= 9 && date.month <= 11)) {
      return 'Autumn';
    } else {
      return 'Winter';
    }
  }

  int getWateringInterval(String level) {
    DateTime now = DateTime.now();
    String season = _getCurrentSeason(now);

    return wateringIntervals[level]?[season] ?? 0; // Fallback auf 0, falls kein Wert gefunden wird
  }



}