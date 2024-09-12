import 'package:flutter/material.dart';
import 'wiki_page_filter_result_page.dart'; // Import the result page

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
        backgroundColor: Colors.blueAccent,
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
            Icons.water_drop_outlined,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantFilterResultPage(filterType: 'water', filterValue: 'low'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Medium',
            Icons.opacity,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantFilterResultPage(filterType: 'water', filterValue: 'medium'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'High',
            Icons.water_drop,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantFilterResultPage(filterType: 'water', filterValue: 'high'),
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
              color: Colors.blue,
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
