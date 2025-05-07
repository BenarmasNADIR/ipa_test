import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../integration/services/api_service.dart';
import '../integration/models/models.dart';
import 'quiz_screen.dart';
import 'history.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Quiz> upcomingQuizzes = [];
  List<Result> quizHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadQuizzes(),
      _loadHistory(),
    ]);
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _apiService.getQuizHistory();
      if (!mounted) return;
      setState(() {
        // Take only the most recent 3 results for the home screen
        quizHistory = history.take(3).toList();
      });
    } catch (e) {
      print('Error loading history: $e');
      // Optionally show an error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load quiz history: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadQuizzes() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Loading assigned quizzes...'); // Add debug log
      final quizzes = await _apiService.getAssignedQuizzes();

      if (!mounted) return;

      setState(() {
        upcomingQuizzes = quizzes.where((quiz) {
          final now = DateTime.now();
          final isUpcoming =
              quiz.startTime != null && now.isBefore(quiz.startTime!);
          final isOngoing = quiz.startTime != null &&
              quiz.endTime != null &&
              now.isAfter(quiz.startTime!) &&
              now.isBefore(quiz.endTime!);

          return (isUpcoming || isOngoing) && !quiz.hasAttempted;
        }).toList();

        // Sort by start time
        upcomingQuizzes.sort((a, b) => (a.startTime ?? DateTime.now())
            .compareTo(b.startTime ?? DateTime.now()));

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quizzes: $e'); // Add debug log
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildUpcomingQuizzes(),
                  const SizedBox(height: 24),
                  _buildYourQuizzes(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFD700),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  'GOOD MORNING',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCCBC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.deepOrange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingQuizzes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Quizzes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          _buildErrorWidget()
        else if (upcomingQuizzes.isEmpty)
          _buildEmptyQuizzesWidget()
        else
          SizedBox(
            height: 280,
            child: Swiper(
              itemBuilder: (context, index) {
                final quiz = upcomingQuizzes[index];
                return QuizCard(quiz: quiz);
              },
              itemCount: upcomingQuizzes.length,
              layout: SwiperLayout.STACK,
              itemWidth: MediaQuery.of(context).size.width * 0.85,
              itemHeight: 240,
              viewportFraction: 0.85,
              scale: 0.9,
            ),
          ),
      ],
    );
  }

  Widget _buildYourQuizzes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Quizzes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (quizHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No quiz history yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...quizHistory.take(3).map((result) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildHistoryCard(result),
              )),
      ],
    );
  }

  Widget _buildHistoryCard(Result result) {
    final double percentage = result.percentageScore;
    final Color progressColor = percentage >= 80
        ? Colors.green
        : percentage >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          result.quizTitle, // Using quiz title from result
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: result.score / result.maxScore,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Score: ${result.score.toStringAsFixed(1)}/${result.maxScore.toStringAsFixed(1)} (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HistoryScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadQuizzes,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQuizzesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No quizzes available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// Keep the existing QuizCard class unchanged

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Time
            Row(
              children: [
                Text(
                  quiz.category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${quiz.timeLimit}min',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Quiz Title
            Text(
              quiz.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Questions Count
            Text(
              '${quiz.questions.length} Questions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            // Shared By and Start Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shared By',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Teacher ${quiz.teacher}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: quiz.canAttempt
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(quiz: quiz),
                            ),
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Start Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
