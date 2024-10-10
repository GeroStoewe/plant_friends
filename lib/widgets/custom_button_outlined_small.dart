import 'package:flutter/material.dart';

class CustomButtonOutlinedSmall extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const CustomButtonOutlinedSmall({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor, // Outline color
            width: 2.0, // Outline width
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14, // Smaller font size for a smaller button
              color: Theme.of(context).primaryColor, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
