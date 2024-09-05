import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Plants",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: const Center(
        child: Text(
            "My Plants",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold
        )
        ),
      )
    );
  }
}