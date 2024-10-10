import 'package:flutter/material.dart';

class CustomButtonSmall extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const CustomButtonSmall({
    super.key,
    required this.onTap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(18)
        ),
        child: Center(
          child: Text(
              text,
              style: Theme.of(context).textTheme.labelMedium
          ),
        ),
      ),
    );
  }
}