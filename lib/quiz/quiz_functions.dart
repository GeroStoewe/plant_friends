import 'package:flutter/material.dart';
import 'quiz_logic.dart'; // Importiere die Spiellogik

class QuizFunctions {
  OverlayEntry? overlayEntry;
  int currentQuestionIndex = 0;
  int careScore = 0;
  int environmentScore = 0;


  void closeQuiz() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showResult(BuildContext context, OverlayState overlayState) {
    bool hasPets = true;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Result',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                Text(
                  'Your care group: ${groups['careGroup']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Your environment group: ${groups['environmentGroup']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (groups['petsWarning']!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      groups['petsWarning']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    closeQuiz();
                  },
                  child: Text('Close'),
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
                      style: Theme.of(context).textTheme.headlineMedium,
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
                    style: Theme.of(context).textTheme.bodyMedium,
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
