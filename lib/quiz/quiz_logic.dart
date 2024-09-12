

class QuizQuestion {

  final String question;
  final List<String> answers;
  final List<int> carePoints;
  final List<int> environmentPoints;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.carePoints,
    required this.environmentPoints,
  });
}

List<QuizQuestion> questions = [
  QuizQuestion(
    question: 'Wie oft denkst du daran, deine Pflanzen zu gießen?',
    answers: ['Täglich', 'Wöchentlich', 'Monatlich', 'Seltener'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Wie viel direktes Sonnenlicht bekommen deine Pflanzen?',
    answers: ['Den ganzen Tag über', 'Einen Teil des Tages', 'Nur indirektes Licht', 'Wenig bis gar kein Tageslicht'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'Wie hoch ist die durchschnittliche Luftfeuchtigkeit an dem Standort?',
    answers: ['Sehr hoch (z.B. Badezimmer oder Küche)', 'Durchschnittlich (Wohnraum)', 'Eher niedrig (z.B. trockene Räume)', 'Sehr niedrig (z.B. in der Nähe von Heizungen)'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'Wie sind die Temperaturen am Standort der Pflanzen?',
    answers: ['ab 18 °C', '10-17 °C', 'schwankend (z.B. wegen Zugluft)', 'unter 10 °C'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'Wie gehst du mit abgestorbenen Blättern oder Blüten um??',
    answers: ['Ich schneide sie sofort ab', 'Ich lasse sie bis zum nächsten Gießen dran', 'Ich entferne sie irgendwann mal', 'Ich entferne sie gar nicht'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Wie oft denkst du daran, deine Pflanzen zu düngen?',
    answers: ['Regelmäßig', 'Ab und zu', 'Selten', 'Gar nicht / Ich dünge nicht'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Wie oft überprüfst du deine Pflanzen auf Schädlinge?',
    answers: ['Regelmäßig', 'Ab und zu', 'Selten', 'Nie'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Wie wichtig ist es dir, dass deine Pflanzen gut gedeihen?',
    answers: ['Sehr wichtig', 'Wichtig', 'Nicht so wichtig', 'Total egal'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Gibt es Haustiere in der Wohnung?',
    answers: ['Ja', 'Nein'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [0, 0, 0, 0],
    //Hier soll Logik hin für einen Haustierhinweis im Ergebnis
  ),
];

// Funktion zur Berechnung der Punktzahl basierend auf den Antworten des Benutzers
Map<String, int> calculateScores(List<int> userAnswers) {
  int careScore = 0;
  int environmentScore = 0;

  for (int i = 0; i < questions.length; i++) {
    int userAnswerIndex = userAnswers[i];

    // Punkte für Pflege und Umgebung hinzufügen basierend auf der Benutzerantwort
    careScore += questions[i].carePoints[userAnswerIndex];
    environmentScore += questions[i].environmentPoints[userAnswerIndex];
  }

  return {
    'careScore': careScore,
    'environmentScore': environmentScore,
  };
}

// Funktion zur Einteilung der Gruppen basierend auf den Scores
Map<String, String> calculateGroups(int careScore, int environmentScore, bool hasPets) {
  String careGroup;
  String environmentGroup;

  // Einteilung für Care Score
  if (careScore >= 15) {
    careGroup = "Gute Pflege";
  } else if (careScore >= 8) {
    careGroup = "Mittlere Pflege";
  } else {
    careGroup = "Schlechte Pflege";
  }

  // Einteilung für Environment Score
  if (environmentScore >= 7) {
    environmentGroup = "Gute Umwelt";
  } else if (environmentScore >= 8) {
    environmentGroup = "Mittlere Umwelt";
  } else {
    environmentGroup = "Schlechte Umwelt";
  }

  // Ergebnis-Map zurückgeben
  return {
    'careGroup': careGroup,
    'environmentGroup': environmentGroup,
    'petsWarning': hasPets ? 'Bitte achten Sie darauf, keine giftigen Pflanzen zu kaufen.' : '',
  };
}

