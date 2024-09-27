import 'package:flutter/material.dart';

import '../themes/colors.dart';

class FilterCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const FilterCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode or light mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: isDarkMode ? dmCardBG : lmCardBG, // Change background color
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
