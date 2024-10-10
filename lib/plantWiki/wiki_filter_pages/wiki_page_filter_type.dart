import 'package:flutter/material.dart';
import '../../../widgets/card_filter.dart';
import '../wiki_page_filter_result_page.dart'; // Import the FilterCard widget

class TypeFilterPage extends StatelessWidget {
  const TypeFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plants by Type',
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
                  title: 'Cacti/Succulents',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_succulent.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Cacti/Succulents'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Tropical Plants',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_alocasia.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Tropical Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Climbing Plants',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_pothos.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Climbing Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Flowering Plants',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_peace-lily.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Flowering Plants'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Trees/Palms',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_bonsai.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Trees/Palms'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Herbs',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_basil.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Herbs'),
                    ),
                  ),
                ),
                FilterCard(
                  title: 'Others',
                  imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_hanging-pot.png',
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
