import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';
import '../../widgets/card_filter.dart';
import '../wiki_page_filter_result_page.dart'; // Import the result page

class DifficultyFilterPage extends StatelessWidget {
  const DifficultyFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plants by Difficulty',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: seaGreen,
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        children: [
          FilterCard(
            title: 'Easy',
            imagePath: 'lib/pages/wiki_images/difficulty/Wiki-Difficulty-1.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'difficulty',
                  filterValue: 'easy',
                ),
              ),
            ),
          ),
          FilterCard(
            title: 'Medium',
            imagePath: 'lib/pages/wiki_images/difficulty/Wiki-Difficulty-2.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'difficulty',
                  filterValue: 'medium',
                ),
              ),
            ),
          ),
          FilterCard(
            title: 'Difficult',
            imagePath: 'lib/pages/wiki_images/difficulty/Wiki-Difficulty-3.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'difficulty',
                  filterValue: 'difficult',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
