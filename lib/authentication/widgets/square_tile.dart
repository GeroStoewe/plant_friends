import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  
  const SquareTile({
    super.key,
    required this.imagePath
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(imagePath, width: 40),
    );
  }
}