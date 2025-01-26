import 'package:flutter/material.dart';

import '../../../widgets/card_filter.dart';
import '../other/wiki_page_filter_result_page.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            imagePath: 'lib/images/wiki/difficulty/Wiki-Difficulty-1.png',
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
            imagePath: 'lib/images/wiki/difficulty/Wiki-Difficulty-2.png',
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
            imagePath: 'lib/images/wiki/difficulty/Wiki-Difficulty-3.png',
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
