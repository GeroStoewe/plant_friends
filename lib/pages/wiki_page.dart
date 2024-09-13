import 'package:flutter/material.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_group.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_light.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_water.dart';
import 'package:plant_friends/pages/wiki_filter_pages/wiki_page_filter_difficulty.dart';
import 'package:plant_friends/pages/wiki_page_filter_result_page.dart';

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
          _buildFilterCard(
            context,
            'All Plants',
            Icons.all_inbox,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'all'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Plants by Type',
            Icons.category,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GroupFilterPage(),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Plants by Water Needs',
            Icons.water,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WaterFilterPage(),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Plants by Light Needs',
            Icons.wb_sunny,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LightFilterPage(),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Plants by Difficulty',
            Icons.star,
                () => Navigator.push(
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

  Widget _buildFilterCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
