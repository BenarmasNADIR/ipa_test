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
      status: json['status'],
    );
  }
}
