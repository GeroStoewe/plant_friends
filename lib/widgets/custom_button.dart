import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;  // Neue Eigenschaft für die Farbe

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,  // Optionale Farbe
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor,  // Standardfarbe, falls keine angegeben
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
