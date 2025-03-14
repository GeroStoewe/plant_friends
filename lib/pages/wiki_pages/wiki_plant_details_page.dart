import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../widgets/custom_info_card.dart';
import '../HelpWithLocalization.dart';
import '../my_plants_pages/add_new_plant_pages/add_new_plant_with_prefilled_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlantWikiDetailPage extends StatelessWidget {
  final dynamic plant;

  const PlantWikiDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context)!;

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
                        nameAndScientificName(context),
                        const SizedBox(height: 30),
                        plantInfo(context),
                        const SizedBox(height: 20), // Space for the description if needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: getPlantTypeImage(),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: seaGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewPlantWithPrefilledData(plant: plant),
                    ),
                  );
                },
                child: Text(
                  '${localizations.addPlantTo} ${localizations.myPlantsWiki}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Container backgroundImageAndHeader(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.50,
      width: size.width,
      child: GestureDetector(
        onTap: () {
          _showFullImageDialog(context);
        },
        child: ClipRRect(
          child: Image.network(
            plant['image_url'] ?? '',
            height: size.height * 0.50,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Positioned backButton(Size size, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: MediaQuery.of(context).padding.top, // Adjust for safe area
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
              color: isDarkMode ? dmLightGrey : lmDarkGrey
          ),
        ),
      ),
    );
  }

  Widget nameAndScientificName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plant['name'] ?? localizations.noName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${plant['scientifical_name'] ?? 'N/A'}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Column plantInfo(BuildContext context) {
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
                value: HelpWithLocalization.getLocalizedLight(plant['light'], localizations) ?? 'N/A',
              ),
            ),
            SizedBox(width: 16), // Add spacing between cards
            Expanded(
              child: CustomInfoCard(
                icon: Icons.water_drop,
                title: localizations.water,
                value: HelpWithLocalization.getLocalizedWater(plant['water'], localizations) ?? 'N/A',
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // Space between rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomInfoCard(
                icon: Icons.star,
                title: localizations.difficulty,
                value: HelpWithLocalization.getLocalizedDifficulty(plant['difficulty'], localizations) ?? 'N/A',
              ),
            ),
            SizedBox(width: 16), // Add spacing between cards
            Expanded(
              child: CustomInfoCard(
                icon: Icons.local_florist,
                title: localizations.plantType,
                value: HelpWithLocalization.getLocalizedPlantType(plant['type'], localizations) ?? 'N/A',
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFullImageDialog(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    final imageUrl = plant['image_url'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: true, // Allows closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.7), // Dark background
          child: Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: isDarkMode ? dmCardBG : lmCardBG,
                          title:  Text(
                            localizations.imageUrl,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          content: Text(
                            imageUrl,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                localizations.close,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the URL dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          localizations.viewUrl,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getPlantTypeImage() {
    String plantType = plant['type'] ?? 'Others';
    switch (plantType) {
      case 'Cacti/Succulents':
        return Image.asset(
          'lib/images/wiki/corner plant/succulent.png',
          width: 120,
          height: 120,
        );
      case 'Tropical Plants':
        return Image.asset(
          'lib/images/wiki/corner plant/alocasia.png',
          width: 120,
          height: 120,
        );
      case 'Climbing Plants':
        return Image.asset(
          'lib/images/wiki/corner plant/pothos.png',
          width: 120,
          height: 120,
        );
      case 'Flowering Plants':
        return Image.asset(
          'lib/images/wiki/corner plant/peace-lily.png',
          width: 120,
          height: 120,
        );
      case 'Trees/Palms':
        return Image.asset(
          'lib/images/wiki/corner plant/bonsai.png',
          width: 120,
          height: 120,
        );
      case 'Herbs':
        return Image.asset(
          'lib/images/wiki/corner plant/basil.png',
          width: 120,
          height: 120,
        );
      case 'Others':
        return Image.asset(
          'lib/images/wiki/corner plant/hanging-pot.png',
          width: 120,
          height: 120,
        );
      default:
        return Image.asset(
          'lib/images/wiki/corner plant/pothos.png',
          width: 120,
          height: 120,
        );
    }
  }
}

