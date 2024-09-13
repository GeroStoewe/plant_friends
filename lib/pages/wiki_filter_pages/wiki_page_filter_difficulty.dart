import 'package:flutter/material.dart';
import '../wiki_page_filter_result_page.dart'; // Importiere die Ergebnis-Seite

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
        backgroundColor: Colors.orangeAccent,
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
            'Easy',
            Icons.star_border,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'difficulty', filterValue: 'easy'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Medium',
            Icons.star_half,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'difficulty', filterValue: 'medium'),
              ),
            ),
          ),
          _buildFilterCard(
            context,
            'Difficult',
            Icons.star_outlined,
                () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(filterType: 'difficulty', filterValue: 'difficult'),
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
              color: Colors.orange,
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
