import 'package:flutter/material.dart';

class CustomBackIconButton extends StatelessWidget {
  final Function()? onTap;

  const CustomBackIconButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,  // Feste Breite für kleines Icon
        height: 40,  // Feste Höhe für kleines Icon
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),  // Runde Ecken
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,  // Zurückgehendes Pfeil-Icon
            size: 20,  // Größe des Icons
            color: Colors.white,  // Farbe des Icons (kann angepasst werden)
          ),
        ),
      ),
    );
  }
}
