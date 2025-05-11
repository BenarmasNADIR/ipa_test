class StudentAnswer {
  final int questionId;
  final int selectedOptionId;

  StudentAnswer({
    required this.questionId,
    required this.selectedOptionId,
  });

  Map<String, dynamic> toJson() => {
        'question': questionId,
        'selected_option': selectedOptionId,
      };

  @override
  String toString() {
    return 'StudentAnswer(question: $questionId, selected_option: $selectedOptionId)';
  }
}
