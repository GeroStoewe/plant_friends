import 'package:flutter/material.dart';

import '../../../themes/colors.dart';
import '../../../widgets/card_filter.dart';
import '../other/wiki_page_filter_result_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TypeFilterPage extends StatelessWidget {
  const TypeFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.plantsByType,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(seaGreen), // Daumenfarbe
          trackColor: WidgetStateProperty.all(Colors.grey.shade300), // Spurfarbe
        ),
        child: Scrollbar(
          thumbVisibility: true, // Immer sichtbar
          child: SingleChildScrollView(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Deaktiviert das Scrollen des GridView
              children: [
                FilterCard(
                  title: localizations.cacti,
                  imagePath: 'lib/images/wiki/corner plant/succulent.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Cacti/Succulents'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.tropicalPlants,
                  imagePath: 'lib/images/wiki/corner plant/alocasia.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Tropical Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.climbingPlants,
                  imagePath: 'lib/images/wiki/corner plant/pothos.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Climbing Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.floweringPlants,
                  imagePath: 'lib/images/wiki/corner plant/peace-lily.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Flowering Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.trees,
                  imagePath: 'lib/images/wiki/corner plant/bonsai.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Trees/Palms'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.herbs,
                  imagePath: 'lib/images/wiki/corner plant/basil.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Herbs'),
                    ),
                  ),
                ),
                FilterCard(
                  title: localizations.others,
                  imagePath: 'lib/images/wiki/corner plant/hanging-pot.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Others'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
