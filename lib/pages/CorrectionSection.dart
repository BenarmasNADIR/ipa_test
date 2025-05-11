import 'package:flutter/material.dart';
import '../integration/models/models.dart';

class CorrectionSection extends StatefulWidget {
  final Result result;

  const CorrectionSection({super.key, required this.result});

  @override
  State<CorrectionSection> createState() => _CorrectionSectionState();
}

class _CorrectionSectionState extends State<CorrectionSection> {
  int _currentQuestion = 0;

  @override
  Widget build(BuildContext context) {
    // Safety check - if no question results, display a message
    if (widget.result.questionResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'No question data available for this quiz',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    final question = widget.result.questionResults[_currentQuestion];
    final total = widget.result.questionResults.length;

    return Column(
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
                  'Quiz Review',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${widget.result.score}/${widget.result.questionResults.length}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Blue progress line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
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

        // Question status indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: question.isCorrect == true
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      question.isCorrect == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: question.isCorrect == true
                          ? Colors.green
                          : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.isCorrect == true ? 'Correct' : 'Incorrect',
                      style: TextStyle(
                        color: question.isCorrect == true
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Question ${_currentQuestion + 1}/$total',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Text(
            question.questionText,
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
              itemCount: question.options.length,
              itemBuilder: (context, idx) {
                // Get the current option
                final option = question.options[idx];

                // Extract option properties safely
                final bool isCorrect = option['is_correct'] == true;
                final bool wasSelected =
                    option['id'] == question.selectedOptionId;
                final String optionText = option['text'] ?? 'Option ${idx + 1}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? Colors.green.shade50
                          : wasSelected && !isCorrect
                              ? Colors.red.shade50
                              : Colors.white,
                      border: Border.all(
                        color: isCorrect
                            ? Colors.green
                            : wasSelected && !isCorrect
                                ? Colors.red
                                : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${String.fromCharCode(97 + idx)}) $optionText',
                            style: TextStyle(
                              fontSize: 16,
                              color: isCorrect
                                  ? Colors.green
                                  : wasSelected && !isCorrect
                                      ? Colors.red
                                      : Colors.black87,
                              fontWeight: isCorrect || wasSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isCorrect)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        else if (wasSelected && !isCorrect)
                          const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Previous',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                const SizedBox(width: 140),
              if (_currentQuestion < total - 1)
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestion++;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Finish',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
