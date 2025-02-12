import 'package:flutter/material.dart';

import '../../../widgets/card_filter.dart';
import '../other/wiki_page_filter_result_page.dart';

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
            title: 'Low Light',
            imagePath: 'lib/images/wiki/light/Wiki-Light-1.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'light',
                  filterValue: 'Low Light',
                ),
              ),
            ),
          ),
          FilterCard(
            title: 'Partial Shade',
            imagePath: 'lib/images/wiki/light/Wiki-Light-2.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'light',
                  filterValue: 'Partial Shade',
                ),
              ),
            ),
          ),
          FilterCard(
            title: 'Indirect Light',
            imagePath: 'lib/images/wiki/light/Wiki-Light-3.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'light',
                  filterValue: 'Indirect Light',
                ),
              ),
            ),
          ),
          FilterCard(
            title: 'Direct Light',
            imagePath: 'lib/images/wiki/light/Wiki-Light-4.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantFilterResultPage(
                  filterType: 'light',
                  filterValue: 'Direct Light',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
