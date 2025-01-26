import 'package:flutter/material.dart';

import '../../widgets/card_filter.dart';
import 'filter_pages/wiki_page_filter_difficulty.dart';
import 'filter_pages/wiki_page_filter_light.dart';
import 'filter_pages/wiki_page_filter_type.dart';
import 'filter_pages/wiki_page_filter_water.dart';
import 'other/wiki_page_filter_result_page.dart';

class WikiPage extends StatelessWidget {
  const WikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Wiki',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Scrollbar(
        // Die Scrollbar zeigt an, dass der Inhalt gescrollt werden kann
        child: SingleChildScrollView(
          // Ermöglicht das Scrollen des Inhalts
          child: GridView.count(
            // Setze `shrinkWrap` auf true und `physics` auf NeverScrollableScrollPhysics
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true, // Damit der GridView die Höhe anpassen kann
            physics: const NeverScrollableScrollPhysics(), // Deaktiviert das Scrollen des GridView
            children: [
              FilterCard(
                title: 'All Plants',
                imagePath: 'lib/images/wiki/category/Wiki-Category-1.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantFilterResultPage(filterType: 'all'),
                  ),
                ),
              ),
              FilterCard(
                title: 'By Type',
                imagePath: 'lib/images/wiki/category/Wiki-Category-2.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TypeFilterPage(),
                  ),
                ),
              ),
              FilterCard(
                title: 'By Water Needs',
                imagePath: 'lib/images/wiki/category/Wiki-Category-3.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WaterFilterPage(),
                  ),
                ),
              ),
              FilterCard(
                title: 'By Light Needs',
                imagePath: 'lib/images/wiki/category/Wiki-Category-4.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LightFilterPage(),
                  ),
                ),
              ),
              FilterCard(
                title: 'By Difficulty',
                imagePath: 'lib/images/wiki/category/Wiki-Category-5.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyFilterPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
