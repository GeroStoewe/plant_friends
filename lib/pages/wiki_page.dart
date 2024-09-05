import 'package:flutter/material.dart';

class WikiPage extends StatelessWidget {
  const WikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wiki",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.green,
      ),
        body: const Center(
          child: Text(
              "Wiki",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              )
          ),
        )
    );
  }
}