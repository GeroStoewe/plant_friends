
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEvent {
  final String title;
  final String description;
  final DateTime date;
  final String id;
  final bool isDone;
  CalendarEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.id,
    required this.isDone
  });

  factory CalendarEvent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return CalendarEvent(
      date: data['date'].toDate(),
      title: data['title'],
      description: data['description'],
      id: snapshot.id,
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "description": description
    };
  }
}