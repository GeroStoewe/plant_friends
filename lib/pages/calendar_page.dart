import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
        body: const Center(
          child: Text(
              "Calendar",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              )
          ),
        )
    );
  }
}