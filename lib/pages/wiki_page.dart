import 'package:flutter/material.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_group.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_light.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_water.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_difficulty.dart';
import 'package:plant_friends/pages/wiki_page_filter_result_page.dart';

import '../widgets/card_filter.dart';

class WikiPage extends StatelessWidget {
  const WikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Filters',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          FilterCard(
            title: 'All Plants',
            imagePath: 'lib/pages/wiki_images/Wiki-Category-1.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'all'),
              ),
            ),
          ),
          FilterCard(
            title: 'By Type',
            imagePath: 'lib/pages/wiki_images/Wiki-Category-2.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GroupFilterPage(),
              ),
            ),
          ),
          FilterCard(
            title: 'By Water Needs',
            imagePath: 'lib/pages/wiki_images/Wiki-Category-3.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WaterFilterPage(),
              ),
            ),
          ),
          FilterCard(
            title: 'By Light Needs',
            imagePath: 'lib/pages/wiki_images/Wiki-Category-4.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LightFilterPage(),
              ),
            ),
          ),
          FilterCard(
            title: 'By Difficulty',
            imagePath: 'lib/pages/wiki_images/Wiki-Category-5.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DifficultyFilterPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}