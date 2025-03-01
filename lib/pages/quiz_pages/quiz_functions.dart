import 'package:flutter/material.dart';
import 'package:plant_friends/pages/quiz_pages/quiz_logic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizFunctions {
  OverlayEntry? overlayEntry;
  int currentQuestionIndex = 0;
  int careScore = 0;
  int environmentScore = 0;
  List<int> userAnswers = []; // Speichert die Antworten als Index
  static bool isQuizActive = false;  // Statische Variable für den Status des Quiz

  void closeQuiz() {
    overlayEntry?.remove();
    overlayEntry = null;
    isQuizActive = false; // Quiz wird geschlossen, kann wieder gestartet werden

    // Zurücksetzen der Quiz-Werte
    currentQuestionIndex = 0;
    careScore = 0;
    environmentScore = 0;
    userAnswers.clear();
  }


  bool hasPets() {
    if (userAnswers.isNotEmpty && userAnswers.length == questions.length) {
      int lastAnswerIndex = userAnswers.last; // Index der Haustierfrage
      return questions.last.answers[lastAnswerIndex] == 'Yes';
    }
    return false;
  }

  void showResult(BuildContext context, OverlayState overlayState) {
    bool pets = hasPets();
    Map<String, String> groups = calculateGroups(careScore, environmentScore, pets);
    final localizations = AppLocalizations.of(context)!;

    overlayEntry = OverlayEntry(
      builder: (context) {
        double textScaleFactor = MediaQuery.of(context).size.width / 375;

        return Positioned(
          bottom: 50.0,
          left: 50.0,
          right: 50.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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
                    localizations.result,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24 * textScaleFactor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${groups['message']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16 * textScaleFactor, // Dynamische Schriftgröße
                    ),
                  ),
                  if (groups['petsWarning']!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        groups['petsWarning']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16 * textScaleFactor, // Dynamische Schriftgröße
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      closeQuiz();
                    },
                    child: Text(localizations.close),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    overlayState.insert(overlayEntry!);
  }

  void checkAnswer(int carePoints, int environmentPoints, BuildContext context, OverlayState overlayState, int answerIndex) {
    careScore += carePoints;
    environmentScore += environmentPoints;
    userAnswers.add(answerIndex); // Antwort speichern

    overlayEntry?.remove(); // Entfernt nur das aktuelle Overlay (nicht das ganze Quiz)

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      showQuestion(context, overlayState); // Zeigt nächste Frage an
    } else {
      showResult(context, overlayState); // Zeigt das Ergebnis, wenn alle Fragen beantwortet wurden
    }
  }


  void showQuestion(BuildContext context, OverlayState overlayState) {
    isQuizActive = true; // Quiz ist aktiv, Button sperren

    overlayEntry = OverlayEntry(
      builder: (context) {
        double textScaleFactor = MediaQuery.of(context).size.width / 375; // Dynamische Schriftgröße basierend auf Bildschirmgröße

        return GestureDetector(
          onTap: () {
            closeQuiz(); // Schließt das Quiz, wenn außerhalb getippt wird
          },
          behavior: HitTestBehavior.opaque, // Erlaubt das Erkennen von Taps auf leere Flächen
          child: Stack(
            children: [
              Positioned(
                bottom: 50.0,
                left: 50.0,
                right: 50.0,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {}, // Verhindert, dass der innere Container das Quiz schließt
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                            questions[currentQuestionIndex].question,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 20 * textScaleFactor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: List.generate(questions[currentQuestionIndex].answers.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    checkAnswer(
                                      questions[currentQuestionIndex].carePoints[index],
                                      questions[currentQuestionIndex].environmentPoints[index],
                                      context,
                                      overlayState,
                                      index,
                                    );
                                  },
                                  child: Text(
                                    questions[currentQuestionIndex].answers[index],
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 16 * textScaleFactor, // Dynamische Schriftgröße
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlayState.insert(overlayEntry!);
  }

}
