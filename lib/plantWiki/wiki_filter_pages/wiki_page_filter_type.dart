import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';
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
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 4,
        ),
        children: [
          FilterCard(
            title:'Cacti/Succulents',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_succulent.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Cacti/Succulents'),
              ),
            ),
          ),
          FilterCard(
            title:'Tropical Plants',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_alocasia.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Tropical Plants'),
              ),
            ),
          ),
          FilterCard(
            title:'Climbing Plants',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_pothos.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Climbing Plants'),
              ),
            ),
          ),
          FilterCard(
            title:'Flowering Plants',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_peace-lily.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Flowering Plants'),
              ),
            ),
          ),
          FilterCard(
            title:'Trees/Palms',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_bonsai.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Trees/Palms'),
              ),
            ),
          ),
          FilterCard(
            title:'Herbs',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_basil.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Herbs'),
              ),
            ),
          ),
          FilterCard(
            title:'Others',
            imagePath: 'lib/plantWiki/wiki_images/type/Wiki_type_hanging-pot.png',
            onTap:
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'type', filterValue: 'Others'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(
      BuildContext context,
      String title,
      String imagePath,
      String filterValue,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantFilterResultPage(
              filterType: 'type',
              filterValue: filterValue,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
