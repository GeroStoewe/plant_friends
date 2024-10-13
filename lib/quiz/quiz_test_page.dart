import 'package:flutter/material.dart';
import 'quiz_overlay.dart'; // Importiere dein Overlay-Handling

class QuizTestPage extends StatefulWidget {
  const QuizTestPage({super.key});

  @override
  _QuizTestPageState createState() => _QuizTestPageState();
}

class _QuizTestPageState extends State<QuizTestPage> {
  OverlayEntry? _quizOverlayEntry; // OverlayEntry auf Klassenebene

  // Funktion zum Anzeigen des Overlays
  void _showQuizOverlay() {
    if (_quizOverlayEntry != null) {
      // Falls das Overlay bereits angezeigt wird, entferne es
      _quizOverlayEntry!.remove();
      _quizOverlayEntry = null;
    }

    _quizOverlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Material(
            elevation: 10.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "This is a quiz question!",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _closeQuiz(); // Quiz schließen
                    },
                    child: Text("Close Quiz"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)!.insert(_quizOverlayEntry!); // Overlay in den Overlay-Stack einfügen
  }

  // Funktion zum Schließen des Overlays
  void _closeQuiz() {
    _quizOverlayEntry?.remove();
    _quizOverlayEntry = null;
  }

  // Wenn die Seite verlassen wird, sicherstellen, dass das Overlay geschlossen wird
  @override
  void dispose() {
    _closeQuiz();
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
              'lib/quiz/images/plantpots.jpg',
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
                    Navigator.pop(context); // Seite verlassen
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
                _showQuizOverlay(); // Zeige das Quiz-Overlay
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
