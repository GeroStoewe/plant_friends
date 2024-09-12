import 'package:flutter/material.dart';
import 'quiz_overlay.dart';

class QuizTestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page for Quiz'),
      ),
      body: Center(
        child: Text('This is the test page to display the Quiz Overlay'),
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
