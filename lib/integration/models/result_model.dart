class QuestionResult {
  final int questionId;
  final String questionText;
  final String questionType;
  final int pointsPossible;
  final int pointsEarned;
  final int? selectedOptionId;
  final String? selectedOptionText;
  final bool? isCorrect;
  final String? textAnswer;
  final bool? isGraded;
  final String? status;

  QuestionResult({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.pointsPossible,
    required this.pointsEarned,
    this.selectedOptionId,
    this.selectedOptionText,
    this.isCorrect,
    this.textAnswer,
    this.isGraded,
    this.status,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['question_id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      pointsPossible: json['points_possible'],
      pointsEarned: json['points_earned'],
      selectedOptionId: json['selected_option_id'],
      selectedOptionText: json['selected_option_text'],
      isCorrect: json['is_correct'],
      textAnswer: json['text_answer'],
      isGraded: json['is_graded'],
      status: json['status'],
    );
  }
}

class Result {
  final int id;
  final int quizId;
  final int studentId;
  final double score;
  final double maxScore;
  final DateTime completedAt;
  final String quizTitle;

  Result({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.score,
    required this.completedAt,
    required this.maxScore,
    required this.quizTitle,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing JSON: $json'); // Debug log
      return Result(
        id: json['id'] ?? 0,
        quizId: json['quiz'] ?? 0,
        studentId: json['student'] ?? 0,
        // Handle string score
        score: double.tryParse(json['score'].toString()) ?? 0.0,
        // Default max score if not provided
        maxScore: 100.0,
        completedAt: DateTime.parse(json['completed_at']),
        // Get quiz title from quiz object or use default
        quizTitle: json['quiz_title'] ?? 'Quiz ${json['quiz'] ?? "Unknown"}',
      );
    } catch (e) {
      print('Error parsing Result: $e'); // Debug log
      rethrow;
    }
  }

  // Calculate percentage score
  double get percentageScore => (score / maxScore) * 100;
}
