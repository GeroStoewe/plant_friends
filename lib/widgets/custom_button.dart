import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double buttonPadding = size.width * 0.05; // Adjust padding based on screen width
    double fontSize = size.width * 0.055; // Responsive font size

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: buttonPadding, horizontal: buttonPadding * 1.5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.05), // Dynamic border radius
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: fontSize, // Adjusted font size
            ),
          ),
        ),
      ),
    );
  }
}
