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
  String careGroup;
  String environmentGroup;

  String goodCareGoodEnvironment;
  String goodCareMediumEnvironment;
  String goodCareBadEnvironment;
  String mediumCareGoodEnvironment;
  String mediumCareMediumEnvironment;
  String mediumCareBadEnvironment;
  String badCareGoodEnvironment;
  String badCareMediumEnvironment;
  String badCareBadEnvironment;

  if (careScore >= 15) {
    careGroup = "Good care";
  } else if (careScore >= 8) {
    careGroup = "Medium care";
  } else {
    careGroup = "Bad care";
  }

  if (environmentScore >= 7) {
    environmentGroup = "Good environment";
  } else if (environmentScore >= 8) {
    environmentGroup = "Medium environment";
  } else {
    environmentGroup = "Bad environment";
  }

 if (careScore >= 15 && environmentScore >= 7) {
   goodCareGoodEnvironment = "You have a green thumb and your space is perfect for plants! With your excellent care and the ideal environment, you can grow almost any plant successfully.";
 } else if (careScore >= 15 && environmentScore >= 7) {
   goodCareMediumEnvironment = "You’re a dedicated plant parente, but your environment might have some minor challenges. Don’t worry – with your commitment, your plants will still thrive!";

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else if (careScore >= 15 && environmentScore >= 7) {

 } else {
   //xxx
 }


  return {
    'careGroup': careGroup,
    'environmentGroup': environmentGroup,
    'petsWarning': hasPets ? 'Pet warning: Do not buy poisonous plants!' : '',
  };
}

