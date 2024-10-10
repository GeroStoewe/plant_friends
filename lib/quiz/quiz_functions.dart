import 'package:flutter/material.dart';
import 'quiz_logic.dart';

class QuizFunctions {
  OverlayEntry? overlayEntry;
  int currentQuestionIndex = 0;
  int careScore = 0;
  int environmentScore = 0;
  List<int> userAnswers = []; // Speichert die Antworten als Index

  void closeQuiz() {
    overlayEntry?.remove();
    overlayEntry = null;
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

    overlayEntry = OverlayEntry(
      builder: (context) {
        // Berechnung der dynamischen Schriftgröße basierend auf Bildschirmgröße
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
                    'Result',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24 * textScaleFactor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'lib/quiz/images/plantiesWallpaper.jpg',
                    height: 130,
                    width: 310,
                    fit: BoxFit.cover,
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
                    child: Text('Close'),
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
    userAnswers.add(answerIndex); // Antworten speichern

    closeQuiz();

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      showQuestion(context, overlayState); // Zeigt nächste Frage
    } else {
      showResult(context, overlayState); // Zeigt Ergebnis, wenn alle Fragen beantwortet wurden
    }
  }

  void showQuestion(BuildContext context, OverlayState overlayState) {
    overlayEntry = OverlayEntry(
      builder: (context) {
        double textScaleFactor = MediaQuery.of(context).size.width / 375; // Dynamische Schriftgröße basierend auf Bildschirmgröße

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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${currentQuestionIndex + 1} of ${questions.length}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 24 * textScaleFactor, // Dynamische Schriftgröße
                        ),
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
                  Center(
                    child: Text(
                      questions[currentQuestionIndex].question,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16 * textScaleFactor, // Dynamische Schriftgröße
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        questions[currentQuestionIndex].answers.length, (index) {
                      return Center(
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
                            style: TextStyle(
                              fontSize: 16 * textScaleFactor, // Gleiche Schriftgröße wie Frage
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
        );
      },
    );

    overlayState.insert(overlayEntry!);
  }
}