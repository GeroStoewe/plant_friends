import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

class CustomCard extends StatelessWidget {
  String headline;
  IconData icon;
  String text;

  CustomCard({
    Key? key,
    required this.headline,
    required this.icon,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                            text: headline,
                            style: const TextStyle(
                          color: seaGreen,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400
                      ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(icon, color: isDarkMode ? Theme.of(context).hintColor : forestGreen, size: 24),
                      const SizedBox(width: 5),
                      Text(
                          text,
                          style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ]
            ),
          )
      );
  }
}