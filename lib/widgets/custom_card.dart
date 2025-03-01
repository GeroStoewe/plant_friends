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
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = size.width / 400;
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
                            style: TextStyle(
                          color: seaGreen,
                          fontSize: 20 * textScaleFactor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400
                      ),
                          ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.0025),
                  Row(
                    children: [
                      Icon(icon, color: isDarkMode ? Theme.of(context).hintColor : forestGreen, size: 24 * textScaleFactor),
                      SizedBox(width: size.width * 0.03),
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