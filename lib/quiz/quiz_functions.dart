// quiz_functions.dart
import 'package:flutter/material.dart';
import 'quiz_logic.dart'; // Importiere die Spiellogik

class QuizFunctions {
  OverlayEntry? overlayEntry; // Verwende 'OverlayEntry?' und initialisiere es mit null
  int currentQuestionIndex = 0;
  int careScore = 0; // Punktzahl für Pflege
  int environmentScore = 0; // Punktzahl für Umgebung

  // Funktion zum Schließen des Quiz
  void closeQuiz() {
    overlayEntry?.remove();
    overlayEntry = null; // Setze das Overlay auf null, wenn es geschlossen wird
  }

  // Funktion zum Anzeigen des Ergebnisses
  void showResult(BuildContext context, OverlayState overlayState) {
    bool hasPets = true; // Beispielannahme, dass der Benutzer ein Haustier hat
    Map<String, String> groups = calculateGroups(careScore, environmentScore, hasPets);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 50.0,
        right: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ergebnis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Du bist in der Pflegegruppe: ${groups['careGroup']}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Du bist in der Umweltgruppe: ${groups['environmentGroup']}',
                  style: TextStyle(fontSize: 18),
                ),
                if (groups['petsWarning']!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      groups['petsWarning']!,
                      style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    closeQuiz();
                  },
                  child: Text('Schließen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlayState.insert(overlayEntry!);
  }

  // Funktion zur Überprüfung der Antwort und Punktzuweisung
  void checkAnswer(int carePoints, int environmentPoints, BuildContext context, OverlayState overlayState) {
    careScore += carePoints;
    environmentScore += environmentPoints;

    // Schließe das aktuelle Overlay (Fragefenster), bevor die nächste Frage angezeigt wird
    closeQuiz();

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      showQuestion(context, overlayState); // Zeige die nächste Frage
    } else {
      showResult(context, overlayState); // Zeige das Ergebnis, wenn alle Fragen beantwortet wurden
    }
  }


  // Funktion zum Anzeigen der aktuellen Frage
  void showQuestion(BuildContext context, OverlayState overlayState) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 50.0,
        right: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Zentriere den Inhalt horizontal
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Frage ${currentQuestionIndex + 1} von ${questions.length}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        closeQuiz();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(  // Center-Widget verwenden, um den Text zu zentrieren
                  child: Text(
                    questions[currentQuestionIndex].question,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,  // Text zentrieren
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Zentriere die Antwortmöglichkeiten
                  children: List.generate(questions[currentQuestionIndex].answers.length, (index) {
                    return Center( // Center-Widget verwenden, um die Buttons zu zentrieren
                      child: ElevatedButton(
                        onPressed: () {
                          checkAnswer(
                            questions[currentQuestionIndex].carePoints[index],
                            questions[currentQuestionIndex].environmentPoints[index],
                            context,
                            overlayState,
                          );
                        },
                        child: Text(questions[currentQuestionIndex].answers[index]),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Overlay anzeigen
    overlayState.insert(overlayEntry!);
  }

}
