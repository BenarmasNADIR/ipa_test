import 'dart:async';
import 'package:flutter/material.dart';
import '../integration/models/models.dart';
import '../integration/services/api_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  Map<int, int> selectedOptions = {};
  bool _isSubmitting = false;
  bool _isTimeUp = false;
  late Timer _timer;
  int _timeRemaining = 0;
  bool _hasShownWarning = false;
  int _currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.quiz.timeLimit * 60;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
          _checkTimeWarning();
        } else {
          _timer.cancel();
          _isTimeUp = true;
          submitQuiz(isTimeUp: true);
        }
      });
    });
  }

  void _checkTimeWarning() {
    if (_timeRemaining == 300 && !_hasShownWarning) {
      _hasShownWarning = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Time Warning'),
          content: const Text('Only 5 minutes remaining!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else if (_timeRemaining == 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('1 minute remaining!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitQuiz({bool isTimeUp = false}) async {
    if (_isSubmitting) return;

    if (!isTimeUp) {
      final shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submit Quiz?'),
          content: const Text(
            'Are you sure you want to submit?\nThis is your only attempt.',
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Review Answers'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (shouldSubmit != true) return;
    }

    setState(() => _isSubmitting = true);
    _timer.cancel();

    try {
      final answers = selectedOptions.entries
          .map((entry) => StudentAnswer(
                questionId: entry.key,
                selectedOptionId: entry.value,
              ))
          .toList();

      final response = await _apiService.submitQuiz(
        widget.quiz.id,
        answers,
        isTimeUp: isTimeUp,
      );

      if (!mounted) return;

      final result = Result.fromJson({
        'quiz_id': widget.quiz.id,
        'quiz_title': widget.quiz.title,
        'score': response['score'],
        'max_score': response['max_score'],
        'percentage_score': response['percentage'],
        'completed_at': DateTime.now().toIso8601String(),
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
        (route) => route.isFirst, // Only keep home screen
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit quiz: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isSubmitting = false);
    }
  }

  bool _validateAnswers() {
    // Check if all questions have been answered
    final unansweredQuestions = widget.quiz.questions
        .where((q) => !selectedOptions.containsKey(q.id))
        .toList();

    if (unansweredQuestions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unanswered Questions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have ${unansweredQuestions.length} unanswered questions:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...unansweredQuestions.map((q) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '• Question ${widget.quiz.questions.indexOf(q) + 1}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )),
              const SizedBox(height: 8),
              const Text('Do you want to submit anyway?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Review Questions'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                submitQuiz();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Submit Anyway'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer.cancel();
    selectedOptions.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestion];
    final total = widget.quiz.questions.length;

    return WillPopScope(
      onWillPop: () async {
        if (_isSubmitting) return false;

        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit Quiz?'),
                content: const Text(
                  'Your progress will be lost and you cannot retake this quiz.',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Continue Quiz'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        body: SafeArea(
          child: _isSubmitting
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Submitting your answers...'),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.quiz.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ],
                      ),
                    ),
                    // Blue progress line
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        children: List.generate(
                          total,
                          (i) => Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color: i <= _currentQuestion
                                    ? Colors.blue
                                    : Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Category and time
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              widget.quiz.category,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${widget.quiz.timeLimit}min',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Question text
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Options
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ListView.builder(
                          itemCount: question.options?.length ?? 0,
                          itemBuilder: (context, idx) {
                            final option = question.options![idx];
                            final isSelected =
                                selectedOptions[question.id] == option.id;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: _isSubmitting
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedOptions[question.id] =
                                              option.id;
                                        });
                                      },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${String.fromCharCode(97 + idx)}) ${option.text}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Navigation buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentQuestion > 0)
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentQuestion--;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'Previous',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 140),
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: selectedOptions[question.id] == null
                                  ? null
                                  : () {
                                      if (_currentQuestion < total - 1) {
                                        setState(() {
                                          _currentQuestion++;
                                        });
                                      } else {
                                        if (_validateAnswers()) {
                                          submitQuiz();
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                _currentQuestion < total - 1
                                    ? 'Next'
                                    : 'Finish',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
