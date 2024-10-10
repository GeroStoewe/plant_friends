import 'package:flutter/material.dart';
import 'quiz_overlay.dart';

class QuizTestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz", style: Theme.of(context).textTheme.labelMedium),
      ),
      body: Center(
        child: Image.asset(
          'lib/quiz/images/ranken.jpg',
          height: 1000,
          width: 500,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showQuizOverlay(context); // Funktion aus quiz_overlay.dart
        },
        child: Icon(Icons.quiz),
      ),
    );
  }
}
