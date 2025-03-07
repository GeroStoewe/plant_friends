import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_friends/pages/HelpWithLocalization.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_button_outlined_small.dart';
import '../../widgets/custom_info_card.dart';
import '../../widgets/custom_snackbar.dart';
import '../calendar_pages/calendar_event_pages/calendar_next_event_card.dart';
import '../calendar_pages/calendar_functions.dart';
import 'my_plants_details_page_edit.dart';
import 'other/my_plants_photo_journal_page.dart';
import 'other/plant.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _showPlantNeedsToBeWateredTodayButWasNotYet = false;



  @override
  void initState() {
    super.initState();

    _nextEventsFuture = _fetchNextEventDates();
    _checkWateringStatus();

  }

  Future<void> _checkWateringStatus() async {
    bool eventNotDone = await CalenderFunctions().checkIfTodaysWateringEventNotDone(widget.plant.key!);
    setState(() {
      _showPlantNeedsToBeWateredTodayButWasNotYet = eventNotDone;
    });
  }

  Future<Map<String, DateTime?>> _fetchNextEventDates() async {
    DateTime? nextWateringDate = await _calendarFunctions.getNextWateringDate(widget.plant.key);
    //DateTime? nextFertilizingDate = await _calendarFunctions.getNextFertilizingDate(widget.plant.key);

    return {
      'watering': nextWateringDate,
      //'fertilizing': nextFertilizingDate,
    };
  }

  void plantWasWateredToday() async {
    final localizations = AppLocalizations.of(context)!;

    bool eventExists = await CalenderFunctions().checkIfTodaysWateringEventExists(widget.plant.key!);

    if (eventExists) {
      await CalenderFunctions().setTodaysWateringEventToDone(widget.plant.key!);
      if (mounted) {
        CustomSnackbar snackbar = CustomSnackbar(context);
        snackbar.showMessage(localizations.wateringDoneMessage, MessageType.success);
        _checkWateringStatus();
      }
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.confirmWateringEventUpdate),
          content: Text(localizations.markedWatered),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                }
              },
              child: Text(localizations.cancel, style: const TextStyle(color: Color(0xFF388E3C))),
            ),
            TextButton(
              onPressed: () async {
                if (mounted) {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                }

                // Ladeindikator anzeigen
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext loadingContext) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)),
                        ),
                      );
                    },
                  );
                }

                try {
                  await CalenderFunctions().deleteAllEventsForPlant(widget.plant.key!);

                  if (widget.plant.plantData?.water == "Custom") {
                    await CalenderFunctions().createNewEventsWateringCustom(
                      widget.plant.key!,
                      widget.plant.plantData?.name ?? 'N/A',
                      widget.plant.plantData?.customWaterInterval ?? 5,
                    );
                  } else {
                    await CalenderFunctions().createNewEventsWatering(
                      widget.plant.key!,
                      widget.plant.plantData?.name ?? 'N/A',
                      widget.plant.plantData?.water ?? localizations.low,
                    );
                  }

                  CalenderFunctions().setTodaysWateringEventToDone(widget.plant.key!);
                  if (mounted) {
                    CustomSnackbar snackbar = CustomSnackbar(context);
                    snackbar.showMessage(localizations.wateringEventsUpdatedSuccessfully, MessageType.success);
                  }
                } catch (e) {
                  if (mounted) {
                    CustomSnackbar snackbar = CustomSnackbar(context);
                    snackbar.showMessage('${localizations.updatingEventsError} $e', MessageType.error);
                  }
                } finally {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop(); // Ladeindikator schließen
                  }
                }
              },
              child: Text(localizations.proceed, style: const TextStyle(color: Color(0xFF388E3C))),
            ),
          ],
        );
      },
    );
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
    String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/plant-friends-app.appspot.com/o/placeholder_plant%2FnoPlant_plant.webp?alt=media&token=6c20d3e6-4b8c-4b59-a677-2340202020a7';

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
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plant.plantData!.name ?? localizations.noName,
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
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(Icons.water_drop,
                      color: _showPlantNeedsToBeWateredTodayButWasNotYet
                          ? Colors.orange
                          : Colors.grey),
                  onPressed: () {
                    plantWasWateredToday();
                  },
                ),
                if (_showPlantNeedsToBeWateredTodayButWasNotYet)
                  Positioned(
                    top: -20,
                    right: -15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        localizations.waterMe,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            )
            ,
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
        ),
      ],
    );
  }

  String _getLocalizedPlantLight(String? light, AppLocalizations localizations) {
    switch (light) {
      case "Direct Light":
        return localizations.directLight;
      case "Indirect Light":
        return localizations.indirectLight;
      case "Partial Shade":
        return localizations.partialShade;
      case "Low Light":
        return localizations.lowLight;
      default:
        return "N/A";
    }
  }

  String _getLocalizedPlantType(String? type, AppLocalizations localizations) {
    switch (type) {
      case "Cacti/Succulents":
        return localizations.cacti;
      case "Tropical Plants":
        return localizations.tropicalPlants;
      case "Climbing Plants":
        return localizations.climbingPlants;
      case "Flowering Plants":
        return localizations.floweringPlants;
      case "Trees/Palms":
        return localizations.trees;
      case "Herbs":
        return localizations.herbs;
      case "Others":
        return localizations.others;
      default:
        return "N/A";
    }
  }

  String _getLocalizedPlantWater(String? water, AppLocalizations localizations) {
    switch (water) {
      case "Low":
        return localizations.low;
      case "Medium":
        return localizations.medium;
      case "High":
        return localizations.high;
      default:
        return "N/A";
    }
  }

  Column plantInfo() {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomInfoCard(
                icon: Icons.wb_sunny,
                title: localizations.light,
                value: _getLocalizedPlantLight(widget.plant.plantData!.light, localizations),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomInfoCard(
                icon: Icons.eco_sharp,
                title: localizations.plantType,
                value: _getLocalizedPlantType(widget.plant.plantData!.type, localizations),
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
                icon: Icons.water_drop,
                title: localizations.water,
                value: HelpWithLocalization.getLocalizedWater(
                  widget.plant.plantData?.water ?? 'N/A', // Fallback auf 'Medium' oder was du bevorzugst
                  localizations,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomInfoCard(
                icon: Icons.water_drop_outlined,
                title: localizations.wateringInterval,
                value: (widget.plant.plantData != null)
                    ? (widget.plant.plantData!.water == 'Custom'
                    ? (widget.plant.plantData!.customWaterInterval != null
                    ? '${widget.plant.plantData!.customWaterInterval} ${localizations.days}'
                    : 'N/A')
                    : '${_calendarFunctions.getWateringInterval(widget.plant.plantData!.water ?? localizations.low)} ${localizations.days}')
                    : 'N/A',
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
              return Text('${localizations.error} ${snapshot.error}');
            } else {
              DateTime? nextWateringDate = snapshot.data?['watering'];
              //DateTime? nextFertilizingDate = snapshot.data?['fertilizing'];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: EventCardNextDate(
                      icon: Icons.calendar_month_outlined,
                      title: localizations.nextWatering,
                      date: nextWateringDate,
                    ),
                  ),
                  /*
                  const SizedBox(width: 16),
                  Expanded(
                    child: EventCardNextDate(
                      icon: Icons.calendar_month_outlined,
                      title: 'Next Fertilizing',
                      date: nextFertilizingDate,
                    ),
                  ),
                   */
                ],
              );
            }
          },
        ),
        const SizedBox(height: 15),
        Center(
          child: CustomButtonOutlinedSmall(
            text: localizations.showPhotoJournal,
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
