import 'package:flutter/material.dart';
import '../wiki_page_filter_result_page.dart'; // Importiere die Ergebnis-Seite

class LightFilterPage extends StatelessWidget {
  const LightFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plants by Light Needs',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellowAccent,
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
            'Low Light',
            Icons.brightness_2,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'light', filterValue: 'Low Light'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Partial Shade',
            Icons.brightness_3,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'light', filterValue: 'Partial shade'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Indirect Light',
            Icons.wb_sunny,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'light', filterValue: 'Indirect sunlight'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Direct Light',
            Icons.wb_sunny_outlined,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'light', filterValue: 'Direct sunlight'),
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
              color: Colors.orangeAccent,
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
