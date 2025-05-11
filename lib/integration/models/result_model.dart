class Result {
  final int id;
  final int quizId;
  final String quizTitle;
  final double score;
  final double maxScore;
  final DateTime completedAt;
  final DateTime quizEndTime;
  final List<QuestionResult> questionResults;

  Result({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.maxScore,
    required this.completedAt,
    required this.quizEndTime,
    this.questionResults = const [],
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    // Parse score values correctly
    double scoreValue;
    double maxScoreValue;

    try {
      // Handle when score is provided as a string
      if (json['score'] is String) {
        scoreValue = double.parse(json['score']);
      } else if (json['score'] is num) {
        scoreValue = (json['score'] as num).toDouble();
      } else {
        scoreValue = 0.0;
      }

      // Handle when max_score is provided as a string
      if (json['max_score'] is String) {
        maxScoreValue = double.parse(json['max_score']);
      } else if (json['max_score'] is num) {
        maxScoreValue = (json['max_score'] as num).toDouble();
      } else {
        maxScoreValue = 0.0;
      }
    } catch (e) {
      // Fallback if parsing fails
      scoreValue = 0.0;
      maxScoreValue = 0.0;
      print('Error parsing score values: $e');
    }

    return Result(
      id: json['id'] ?? 0,
      quizId: json['quiz'] ?? 0,
      quizTitle: json['quiz_title'] ?? 'Unknown Quiz',
      score: scoreValue,
      maxScore: maxScoreValue,
      completedAt: DateTime.parse(json['completed_at']),
      quizEndTime: DateTime.parse(json['quiz_end_time']),
      questionResults: (json['questions'] as List?)
              ?.map((q) => QuestionResult.fromJson(q))
              .toList() ??
          [],
    );
  }

  double get percentageScore => maxScore > 0 ? (score / maxScore) * 100 : 0;
}

class QuestionResult {
  final int questionId;
  final String questionText;
  final String questionType;
  final int pointsPossible;
  final double pointsEarned; // Changed to double
  final int? selectedOptionId;
  final String? selectedOptionText;
  final bool? isCorrect;
  final String? textAnswer;
  final bool? isGraded;
  final String? status;
  final List<Map<String, dynamic>> options;

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
    this.options = const [],
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    // Handle the points_earned field, which can be a double or an int
    double pointsEarned;

    try {
      if (json['points_earned'] is String) {
        pointsEarned = double.parse(json['points_earned']);
      } else if (json['points_earned'] is num) {
        pointsEarned = (json['points_earned'] as num).toDouble();
      } else {
        pointsEarned = 0.0;
      }
    } catch (e) {
      pointsEarned = 0.0;
      print('Error parsing points_earned: $e');
    }

    return QuestionResult(
      questionId: json['question_id'] ?? 0,
      questionText: json['question_text'] ?? 'Unknown Question',
      questionType: json['question_type'] ?? 'unknown',
      pointsPossible: json['points'] ?? json['points_possible'] ?? 0,
      pointsEarned: pointsEarned,
      selectedOptionId: json['selected_option_id'],
      selectedOptionText: json['selected_option_text'],
      isCorrect:
          json['is_correct'], // Keep this as is, it's coming from the API
      textAnswer: json['text_answer'],
      isGraded: json['is_graded'],
      status: json['status'],
      options: (json['options'] as List<dynamic>?)
              ?.map((o) => Map<String, dynamic>.from(o))
              .toList() ??
          [],
    );
  }
}
