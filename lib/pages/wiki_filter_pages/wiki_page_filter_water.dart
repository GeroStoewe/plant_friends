import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';
import '../wiki_page_filter_result_page.dart'; // Import the result page

class WaterFilterPage extends StatelessWidget {
  const WaterFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plants by Water Needs',
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
          _buildFilterCard(
            context,
            'Low',
            'lib/pages/wiki_images/water/Wiki-Water-1.png',
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'water', filterValue: 'low'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Medium',
            'lib/pages/wiki_images/water/Wiki-Water-2.png',
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'water', filterValue: 'medium'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'High',
            'lib/pages/wiki_images/water/Wiki-Water-3.png',
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'water', filterValue: 'high'),
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
      String imagePath, // Add an image path parameter
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
