// quiz_overlay.dart
import 'package:flutter/material.dart';
import 'quiz_functions.dart'; // Importiere die ausgelagerten Funktionen

// Quiz Overlay
void showQuizOverlay(BuildContext context) {
  OverlayState overlayState = Overlay.of(context)!;
  QuizFunctions quizFunctions = QuizFunctions();

  // Zeige die erste Frage und übergebe den BuildContext und OverlayState
  quizFunctions.showQuestion(context, overlayState);
}
