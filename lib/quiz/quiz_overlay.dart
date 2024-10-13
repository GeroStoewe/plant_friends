// quiz_overlay.dart
import 'package:flutter/material.dart';
import 'quiz_functions.dart';

// Quiz Overlay
OverlayEntry showQuizOverlay(BuildContext context) { // Funktion gibt OverlayEntry zurück
  OverlayState overlayState = Overlay.of(context)!;
  QuizFunctions quizFunctions = QuizFunctions();

  // Zeige die erste Frage und übergebe den BuildContext und OverlayState
  quizFunctions.showQuestion(context, overlayState);

  return quizFunctions.overlayEntry!; // Gibt das Overlay zurück, um es später zu schließen
}