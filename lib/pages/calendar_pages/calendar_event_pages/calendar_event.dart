import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEvent{
  final String id;
  final String plantID;
  final String plantName;
  final String eventType;
  final bool isDone;
  final DateTime date;

  CalendarEvent({
    required this.id,
    required this.plantID,
    required this.plantName,
    required this.eventType,
    required this.isDone,
    required this.date,
  });

  factory CalendarEvent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return CalendarEvent(
      date: data['date'].toDate(),
      plantID: data['plantID'],
      plantName: data['plantName'],
      id: snapshot.id,
      isDone: data['isDone'] ?? false,
      eventType: data['eventType'] ?? '',
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'plantID': plantID,
      'plantName': plantName,
      'eventType': eventType,
      'isDone': isDone,
      'date': Timestamp.fromDate(date),
    };
  }
}