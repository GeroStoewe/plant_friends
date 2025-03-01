import 'package:flutter/material.dart';

import '../../../widgets/card_filter.dart';
import '../other/wiki_page_filter_result_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DifficultyFilterPage extends StatelessWidget {
  const DifficultyFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.plantsByDifficulty,
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
            title: localizations.easy,
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
            title: localizations.medium,
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
            title: localizations.difficult,
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
