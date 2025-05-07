class StudentAnswer {
  final int questionId;
  final int selectedOptionId;

  StudentAnswer({
    required this.questionId,
    required this.selectedOptionId,
  });

  Map<String, dynamic> toJson() => {
        'question': questionId, // Make sure these field names match
        'selected_option': selectedOptionId // what the backend expects
      };
}
