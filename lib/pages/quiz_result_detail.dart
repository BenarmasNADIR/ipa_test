import 'package:flutter/material.dart';
import '../integration/services/api_service.dart';
import '../integration/models/models.dart';

class QuizResultDetailScreen extends StatelessWidget {
  final Result result;

  const QuizResultDetailScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result.quizTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreCard(),
            const SizedBox(height: 24),
            const Text(
              'Question Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...result.questionResults.map(_buildQuestionCard),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    final percentage = result.percentageScore;
    final Color progressColor = percentage >= 80
        ? Colors.green
        : percentage >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
            Text(
              'Score: ${result.score.toStringAsFixed(1)}/${result.maxScore.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: result.score / result.maxScore,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionResult question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (question.selectedOptionText != null) ...[
              Row(
                children: [
                  Icon(
                    question.isCorrect == true
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        question.isCorrect == true ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your answer: ${question.selectedOptionText}',
                      style: TextStyle(
                        color: question.isCorrect == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Not answered',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Points: ${question.pointsEarned}/${question.pointsPossible}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
