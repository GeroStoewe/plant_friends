import 'package:flutter/material.dart';
import 'package:plant_friends/pages/quiz_pages/quiz_functions.dart';

class QuizTestPage extends StatefulWidget {
  const QuizTestPage({super.key});

  @override
  _QuizTestPageState createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  final QuizFunctions quizFunctions = QuizFunctions();

  @override
  void dispose() {
    // Beim Verlassen der Seite wird das Quiz automatisch geschlossen
    quizFunctions.closeQuiz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Hintergrundbild mit stärkerer Transparenz (blasser)
          Positioned.fill(
            child: Image.asset(
              'lib/images/welcome/plantpots.jpg', // Ersetze durch dein Bild
              fit: BoxFit.cover,
              color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.0),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Inhalt der Seite
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zurück-Button oben links
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.white10 : Colors.black12,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 28.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Begrüßungstext und Erklärung
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to the Quiz!",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Here we will ask about your room conditions and plant care habits. Based on your answers, we will recommend the best plants that suit you.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Let's get started!",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),

          // Floating Action Button unten rechts
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Quiz wird nur gestartet, wenn noch kein aktives Quiz läuft
                if (!QuizFunctions.isQuizActive) {
                  OverlayState overlayState = Overlay.of(context)!;
                  quizFunctions.showQuestion(context, overlayState);
                }
              },
              label: Text(
                'Start Quiz',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              icon: const Icon(
                Icons.quiz,
                color: Colors.white, // Farbe des Icons bleibt weiß im Dark und Light Mode
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
