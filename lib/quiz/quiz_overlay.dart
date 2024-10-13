import 'package:flutter/material.dart';
import 'quiz_functions.dart';

// Quiz Overlay
void showQuizOverlay(BuildContext context) {
  QuizFunctions quizFunctions = QuizFunctions();

  // Wenn bereits ein Quiz läuft, verhindern wir das erneute Öffnen.
  if (QuizFunctions.isQuizActive) {
    return; // Blockiere das erneute Starten, wenn das Quiz aktiv ist.
  }

  OverlayState overlayState = Overlay.of(context)!;

  // Zeige die erste Frage und übergebe den BuildContext und OverlayState
  quizFunctions.showQuestion(context, overlayState);
}
