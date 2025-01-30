import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button_outlined_small.dart';
import '../../widgets/custom_info_card.dart';
import '../calendar_pages/calendar_event_pages/calendar_next_event_card.dart';
import '../calendar_pages/calendar_functions.dart';
import 'my_plants_details_page_edit.dart';
import 'other/my_plants_photo_journal_page.dart';
import 'other/plant.dart';

class MyPlantsDetailsPage extends StatefulWidget {
  final Plant plant;
  final DatabaseReference dbRef;
  const MyPlantsDetailsPage({super.key, required this.plant, required this.dbRef});

  @override
  State<MyPlantsDetailsPage> createState() => _MyPlantsDetailsPage();
}

class _MyPlantsDetailsPage extends State<MyPlantsDetailsPage> {

  final CalenderFunctions _calendarFunctions = CalenderFunctions();
  late Future<Map<String, DateTime?>> _nextEventsFuture;



  @override
  void initState() {
    super.initState();

    _nextEventsFuture = _fetchNextEventDates();
  }

  Future<Map<String, DateTime?>> _fetchNextEventDates() async {
    DateTime? nextWateringDate = await _calendarFunctions.getNextWateringDate(widget.plant.key);
    DateTime? nextFertilizingDate = await _calendarFunctions.getNextFertilizingDate(widget.plant.key);

    return {
      'watering': nextWateringDate,
      'fertilizing': nextFertilizingDate,
    };
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            backgroundImageAndHeader(size, context),
            backButton(size, context),
            Positioned(
              bottom: 0,
              child: Container(
                height: size.height * 0.55,
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        nameAndScientificName(),
                        const SizedBox(height: 30),
                        plantInfo(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container backgroundImageAndHeader(Size size, BuildContext context) {
    String imageUrl = widget.plant.plantData!.imageUrl ?? '';
    String defaultImageUrl = 'https://media.istockphoto.com/id/1280154279/de/foto/geben-sie-ihrem-haus-eine-gute-dosis-gr%C3%BCn.jpg?s=2048x2048&w=is&k=20&c=_lcpTxNP6AQsufXbQPb4bOZirU7oo-M8Z7184h3ILGM=';

    return Container(
      height: size.height * 0.50,
      width: size.width,
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          child: Image.network(
            imageUrl.isNotEmpty ? imageUrl : defaultImageUrl,
            height: size.height * 0.50,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(seaGreen),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },

            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 100, color: Colors.red);
            },
          ),
        ),
      ),
    );
  }


  Positioned backButton(Size size, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDarkMode ? dmLightGrey : lmDarkGrey,
          ),
        ),
      ),
    );
  }

  Widget nameAndScientificName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plant.plantData!.name ?? 'No name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.plant.plantData!.scienceName ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.cake, // Geburtstagstorte Icon
                    size: 16,   // Kleine Größe für das Icon
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.plant.plantData!.date != null
                        ? widget.plant.plantData!.date!
                        : 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            // Navigiere zur Edit-Seite und warte auf das Ergebnis
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyPlantsDetailsEditPage(plant: widget.plant),
              ),
            );

            // Wenn das Ergebnis true ist, aktualisiere die Seite
            if (result == true) {
              setState(() {
                _nextEventsFuture = _fetchNextEventDates(); // Update next events
              });
            }
          },
        ),
      ],
    );
  }


  Column plantInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomInfoCard(
                icon: Icons.wb_sunny,
                title: 'Light',
                value: widget.plant.plantData!.light ?? 'N/A',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomInfoCard(
                icon: Icons.water_drop,
                title: 'Water',
                value: widget.plant.plantData!.water ?? 'N/A',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomInfoCard(
                icon: Icons.star,
                title: 'Difficulty',
                value: widget.plant.plantData!.difficulty ?? 'N/A',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomInfoCard(
                icon: Icons.eco_sharp,
                title: 'Plant Type',
                value: widget.plant.plantData!.type ?? 'N/A',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FutureBuilder<Map<String, DateTime?>>(
          future: _nextEventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(seaGreen),);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              DateTime? nextWateringDate = snapshot.data?['watering'];
              DateTime? nextFertilizingDate = snapshot.data?['fertilizing'];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: EventCardNextDate(
                      icon: Icons.calendar_month_outlined,
                      title: 'Next Watering',
                      date: nextWateringDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EventCardNextDate(
                      icon: Icons.calendar_month_outlined,
                      title: 'Next Fertilizing',
                      date: nextFertilizingDate,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 15),
        Center(
          child: CustomButtonOutlinedSmall(
            text: 'Show photo journal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoJournalPage(plantID: widget.plant.key),
                ),
              );
            },
          ),
        ),
      ],
     );

  }

}
