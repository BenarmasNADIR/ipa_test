class QuizAttempt {
  final int id;
  final int quizId;
  final int studentId;
  final int attemptNumber;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.attemptNumber,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'],
      quizId: json['quiz'],
      studentId: json['student'],
      attemptNumber: json['attempt_number'],
      startedAt: DateTime.parse(json['started_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quiz': quizId,
        'student': studentId,
        'attempt_number': attemptNumber,
        'started_at': startedAt.toIso8601String(),
        if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
        'is_completed': isCompleted,
      };
}
