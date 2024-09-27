import 'package:cloud_firestore/cloud_firestore.dart';

class CalenderFunctions {

  Map<String, Map<String, int>> wateringIntervals = {
    'Low': {
      'Spring': 19,
      'Summer': 19,
      'Autumn': 26,
      'Winter': 28,
    },
    'Medium': {
      'Spring': 12,
      'Summer': 8,
      'Autumn': 12,
      'Winter': 19,
    },
    'High': {
      'Spring': 5,
      'Summer': 4,
      'Autumn': 6,
      'Winter': 12,
    },
  };

  Future<void> createNewEventsWatering(String plantID, String plantName, String waterNeeds) async {
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


  Future<void> createNewEventsFertilizing(String plantID, String plantName, int dayInterval) async {
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

  Future<DateTime?> getNextWateringDate(String plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();

    try {
      // Adjust now to include today's date regardless of the current time
      DateTime today = DateTime(now.year, now.month, now.day);

      // Query Firestore for future watering events for the given plantID
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
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

  Future<DateTime?> getNextFertilizingDate(String plantID) async {
    final firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();

    try {
      // Adjust now to include today's date regardless of the current time
      DateTime today = DateTime(now.year, now.month, now.day);

      // Query Firestore for future fertilizing events for the given plantID
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('plantID', isEqualTo: plantID)
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

  Future<void> _createEventsInRangeWatering(
      DateTime startDate,
      DateTime endDate,
      String plantID,
      String plantName,
      String eventType,
      String waterNeeds,
      ) async {
    final firestore = FirebaseFirestore.instance;
    DateTime currentDate = startDate;

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

}