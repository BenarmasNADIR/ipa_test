// question_model.dart
// Contains Question and Option models

class Question {
  final int id;
  final int quizId;
  final String text;
  final String questionType; // 'mcq', 'tf', 'text'
  final int point;
  final List<Option>? options;

  Question({
    required this.id,
    required this.quizId,
    required this.text,
    required this.questionType,
    required this.point,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Option>? optionsList;
    if (json['options'] != null) {
      optionsList =
          List<Option>.from(json['options'].map((o) => Option.fromJson(o)));
    }

    return Question(
      id: json['id'],
      quizId: json['quiz'],
      text: json['text'],
      questionType: json['question_type'],
      point: json['point'] ?? 0,
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quiz': quizId,
        'text': text,
        'question_type': questionType,
        'point': point,
      };
}

class Option {
  final int id;
  final String text;
  final bool isCorrect;

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'is_correct': isCorrect,
      };
}
