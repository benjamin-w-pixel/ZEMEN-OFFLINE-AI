class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({required this.question, required this.options, required this.correctIndex});
}

class AcademicService {
  /// Generates a quiz based on a subject.
  /// In Phase 4, this would use the offline brain to extract facts from the database.
  static List<QuizQuestion> generateQuiz(String subject) {
    if (subject == "Mathematics") {
      return [
        QuizQuestion(
          question: "What is the result of 15 * 12?",
          options: ["160", "180", "150", "190"],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: "Solve for x: 2x + 5 = 15",
          options: ["5", "10", "7.5", "2.5"],
          correctIndex: 0,
        ),
      ];
    }
    
    return [
      QuizQuestion(
        question: "General Knowledge: Who is the Ultimate Professor?",
        options: ["A Bot", "Zemen AI", "A Search Engine", "A Calculator"],
        correctIndex: 1,
      ),
    ];
  }
}
