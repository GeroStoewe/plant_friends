import 'package:flutter/material.dart';
import 'package:plant_friends/themes/colors.dart';

class CustomCardButton extends StatelessWidget {
  final Image image;
  final String text;
  final VoidCallback onTap;

  CustomCardButton({
    Key? key,
    required this.image,
    required this.text,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = size.width / 400;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60 * textScaleFactor,
                    width: 60 * textScaleFactor,
                    child: image,
                  ),
                  SizedBox(height: 0.01 * size.height),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                ]
            ),
          )
      ),
    );
  }
}