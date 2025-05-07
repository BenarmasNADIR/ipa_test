import 'question_model.dart';

class Quiz {
  final int id;
  final String title;
  final String description;
  final int teacher;
  final List<int> assignedStudents;
  final List<int> assignedGroups;
  final int timeLimit;
  final bool hasAttempted; // New field
  final bool isPublished;
  final String category;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<Question> questions;
  final bool isActive;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.teacher,
    required this.assignedStudents,
    required this.assignedGroups,
    required this.timeLimit,
    this.hasAttempted = false, // New field
    required this.isPublished,
    required this.category,
    this.startTime,
    this.endTime,
    required this.questions,
    required this.isActive,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    try {
      return Quiz(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        teacher: json['teacher'] ?? 0,
        assignedStudents: List<int>.from(json['assigned_students'] ?? []),
        assignedGroups: List<int>.from(json['assigned_groups'] ?? []),
        timeLimit: json['time_limit'] ?? 0,
        hasAttempted: json['has_attempted'] ?? false,
        isPublished: json['is_published'] ?? false,
        category: json['category'] ?? 'Uncategorized',
        startTime: json['start_time'] != null
            ? DateTime.parse(json['start_time'])
            : null,
        endTime:
            json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
        questions: json['questions'] != null
            ? List<Question>.from(
                json['questions'].map((q) => Question.fromJson(q)))
            : [],
        isActive: json['is_active'] ?? false,
      );
    } catch (e) {
      print('Error parsing Quiz: $e'); // Add debug log
      rethrow;
    }
  }

  bool get canAttempt => isActive && !hasAttempted; // Modified
}
