import 'package:flutter/material.dart';

class PlantWikiPage extends StatelessWidget {
  const PlantWikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Wiki'),
      ),
      body: const Center(
        child: Text('Plant Wiki Page'),
      ),
    );
  }
}