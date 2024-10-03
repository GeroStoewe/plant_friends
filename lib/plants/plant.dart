class Plant{
  String? key;
  PlantData? plantData;

  Plant({this.key,this.plantData});
}

class PlantData {
  String? name;
  String? scienceName;
  String? date;
  String? imageUrl;

  PlantData({this.name,this.scienceName, this.date, this.imageUrl});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    scienceName = json["science_name"];
    date = json["date"];
    imageUrl = json["image_url"];
  }
}

//TODO: modify this code to use this structure:
/*
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventTest {
  final String id;
  final String plantID;
  final String plantName;
  final String eventType;
  final bool isDone;
  final DateTime date;

  CalendarEventTest({
    required this.id,
    required this.plantID,
    required this.plantName,
    required this.eventType,
    required this.isDone,
    required this.date,
  });

  factory CalendarEventTest.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return CalendarEventTest(
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
} */