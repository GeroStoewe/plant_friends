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
    question: 'How often do you remember to water your plants?',
    answers: ['Daily', 'Weekly', 'Monthly', 'Irregularly'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'How much direct sunlight do your plants get?',
    answers: ['The whole day', 'A part of the day', 'Only indirect sunlight', 'Minimal to no sunlight'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'How is the general humidity?',
    answers: ['High (e.g. bathroom, kitchen)', 'Medium (e.g. living room)', 'Low (e.g. garage)', 'Very low (e.g. close to the heating)'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'How is the temprature?',
    answers: ['above 18 °C', '10-17 °C', 'fluctuating (e.g. open windows)', 'below 10 °C'],
    carePoints: [0, 0, 0, 0],
    environmentPoints: [3, 2, 1, 0],
  ),
  QuizQuestion(
    question: 'How do you deal with dead parts of a plant?',
    answers: ['I cut them off immediately', 'I remove them with the next watering', 'I remove them later', 'I never remove them'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'How often do you remember using fertilizer?',
    answers: ['Regularly', 'From time to time', 'Rarely', 'Never'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'How often do you check your plants for bugs or diseases?',
    answers: ['Regularly', 'From time to time', 'Rarely', 'Never'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'How important are your plants to you?',
    answers: ['Sehr wichtig', 'Wichtig', 'Nicht so wichtig', 'Total egal'],
    carePoints: [3, 2, 1, 0],
    environmentPoints: [0, 0, 0, 0],
  ),
  QuizQuestion(
    question: 'Do you have any pets?',
    answers: ['Yes', 'No'],
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

Map<String, String> calculateGroups(int careScore, int environmentScore, bool hasPets) {

  String message;

 if (careScore >= 15 && environmentScore >= 7) {
   message = "You have a green thumb and your space is perfect for plants! With your excellent care and the ideal environment, you can grow almost any plant successfully.";
 } else if (careScore >= 15 && environmentScore >= 4) {
   message = "You’re a dedicated plant parent, but your environment might have some minor challenges. Don’t worry – with your commitment, your plants will still thrive!";
 } else if (careScore >= 15 && environmentScore >= 0) {
   message = "Your care for plants is top-notch, but the environment isn’t the easiest. Luckily, your attentiveness will help you keep even the hardiest plants happy.";
 } else if (careScore >= 8 && environmentScore >= 7) {
  message = "You have a great environment for plants, and with just a little bit of effort, your plants will flourish. A few low-maintenance plants could be perfect for you.";
 } else if (careScore >= 8 && environmentScore >= 4) {
   message = "You’re a relaxed plant parent, and your environment is fairly average. Choose plants that are easygoing and don’t need too much fuss – they’ll fit right in!";
 } else if (careScore >= 8 && environmentScore >= 0) {
   message = "You have a bit of a challenge with your environment and you prefer low-maintenance plants. Opt for plants that are almost impossible to kill and can handle tougher conditions.";
 } else if (careScore >= 0 && environmentScore >= 7) {
   message = "Your space is a plant's dream home, but you don’t have much time or interest in intensive care. Easy-to-grow plants are just right for you.";
 } else if (careScore >= 0 && environmentScore >= 4) {
   message = "You’re not overly attentive when it comes to plant care, and your environment isn’t perfect either. Stick to plants that don’t mind a bit of neglect and can still thrive.";
 } else if (careScore >= 0 && environmentScore >= 0) {
   message = "Your environment presents some challenges, and you’re not one to fuss over plants. Look for ultra-tough, low-maintenance plants that can handle a bit of a rough patch.";
 } else {
   message = "Error! Please restart the quiz.";
 }

  return {
    'petsWarning': hasPets ? 'Pet warning: Check which plants are poisonous!' : '',
    'message' : message,
  };
}

