import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/pages/calendar/next_Event_widget.dart';
import 'package:plant_friends/pages/test_my_plants_wiki_autofil.dart';
import 'calendar/calendar_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final CalenderFunctions _calendarFunctions = CalenderFunctions();
  final String plantID = "test_plant"; // Example plantID

  // Future to fetch the next event dates
  late Future<Map<String, DateTime?>> _nextEventsFuture;

  @override
  void initState() {
    super.initState();
    _nextEventsFuture = _fetchNextEventDates();
  }

  Future<Map<String, DateTime?>> _fetchNextEventDates() async {
    DateTime? nextWateringDate = await _calendarFunctions.getNextWateringDate(plantID);
    DateTime? nextFertilizingDate = await _calendarFunctions.getNextFertilizingDate(plantID);

    return {
      'watering': nextWateringDate,
      'fertilizing': nextFertilizingDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Directory"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, DateTime?>>(
              future: _nextEventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Extract the next event dates
                  DateTime? nextWateringDate = snapshot.data?['watering'];
                  DateTime? nextFertilizingDate = snapshot.data?['fertilizing'];

                  return Column(
                    children: [
                      EventCardNextDate(
                        icon: Icons.water_drop,
                        title: 'Next Watering',
                        date: nextWateringDate,
                      ),
                      const SizedBox(height: 10),
                      EventCardNextDate(
                        icon: Icons.local_florist,
                        title: 'Next Fertilizing',
                        date: nextFertilizingDate,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 40), // Space between date display and buttons
            ElevatedButton(
              onPressed: () async {
                String plantName = "Aloe Vera";
                String wateringNeeds = "High";

                // Call the watering function
                await _calendarFunctions.createNewEventsWatering(plantID, plantName, wateringNeeds);

                // Refresh the dates after creating new events
                setState(() {
                  _nextEventsFuture = _fetchNextEventDates();
                });
              },
              child: const Text("Create Watering Events"),
            ),
            const SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () async {
                String plantName = "Aloe Vera";
                int dayInterval = 30; // Fertilize every 30 days

                // Call the fertilizing function
                await _calendarFunctions.createNewEventsFertilizing(plantID, plantName, dayInterval);

                // Refresh the dates after creating new events
                setState(() {
                  _nextEventsFuture = _fetchNextEventDates();
                });
              },
              child: const Text("Create Fertilizing Events"),
            ),
            const SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () async {
                // Call the delete function
                await _calendarFunctions.deleteAllEventsForPlant(plantID);

                // Refresh the dates after deletion
                setState(() {
                  _nextEventsFuture = _fetchNextEventDates();
                });
              },
              child: const Text("Delete All Events for Plant"),
            ),
            const SizedBox(height: 20), // Space between buttons

            // New button to navigate to the Wiki search page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WikiSearchPage(),
                  ),
                );
              },
              child: const Text("Go to Wiki Search"),
            ),
          ],
        ),
      ),
    );
  }
}
