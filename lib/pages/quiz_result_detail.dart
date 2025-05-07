import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../integration/services/api_service.dart';
import '../integration/models/models.dart';
import 'quiz_screen.dart';
import 'history.dart';

class QuizResultDetailScreen extends StatefulWidget {
  final int quizId;
  final String quizTitle;

  const QuizResultDetailScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizResultDetailScreen> createState() => _QuizResultDetailScreenState();
}

class _QuizResultDetailScreenState extends State<QuizResultDetailScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _resultData;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    try {
      final result = await _apiService.getQuizDetailedResult(widget.quizId);
      setState(() {
        _resultData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resultData == null
              ? const Center(child: Text('Failed to load result'))
              : SingleChildScrollView(
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
                      ..._buildQuestionResults(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildScoreCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${_resultData!['percentage_score'].toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Score: ${_resultData!['score']}/${_resultData!['max_score']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionResults() {
    final questionResults = _resultData!['question_results'] as List;
    return questionResults.map((q) => _buildQuestionCard(q)).toList();
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    final isCorrect = question['is_correct'] ?? false;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question_text'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your answer: ${question['selected_option_text'] ?? 'Not answered'}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Points: ${question['points_earned']}/${question['points_possible']}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
