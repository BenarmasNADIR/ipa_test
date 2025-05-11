import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  final String baseUrl = 'http://10.175.237.226:8000/api';
  String? _authToken;

  // Get stored token
  Future<String?> get authToken async {
    if (_authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
    }
    return _authToken;
  }

  // Set auth token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get auth headers
  Future<Map<String, String>> get headers async {
    final token = await authToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  // ====================== USER ENDPOINTS ======================

  // Login method
  Future<User> login(String username, String password) async {
    try {
      final url = '$baseUrl/users/login/';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['access'] != null) {
          await setAuthToken(data['access']);
        } else if (data['token'] != null) {
          await setAuthToken(data['token']);
        } else {
          throw Exception('Token missing in response');
        }

        return User.fromJson({
          'id': data['id'],
          'username': data['username'],
          'email': data['email'],
          'role': data['role'],
          'token': data['access'] ?? data['token'],
        });
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
            error['detail'] ?? error['error'] ?? 'Invalid credentials');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/users/logout/'),
        headers: await headers,
      );
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _authToken = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }

  // ====================== QUIZ ENDPOINTS ======================

  // Get all quizzes
  Future<List<Quiz>> getQuizzes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/quizzes/'),
        headers: await headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((quiz) => Quiz.fromJson(quiz)).toList();
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load quizzes: $e');
    }
  }

  // Get assigned quizzes
  Future<List<Quiz>> getAssignedQuizzes() async {
    try {
      print('Fetching assigned quizzes...'); // Add debug log
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/quizzes/assigned/'),
        headers: await headers,
      );

      print('Response status: ${response.statusCode}'); // Add debug log
      print('Response body: ${response.body}'); // Add debug log

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final now = DateTime.now();

        // Convert to Quiz objects and filter
        final quizzes = data
            .map((quiz) {
              try {
                return Quiz.fromJson(quiz);
              } catch (e) {
                print('Error parsing quiz: $e');
                return null;
              }
            })
            .where((quiz) =>
                quiz != null &&
                quiz.isActive &&
                quiz.endTime != null &&
                quiz.endTime!.isAfter(now))
            .cast<Quiz>()
            .toList();

        // Sort by start time
        quizzes.sort((a, b) => (a.startTime ?? DateTime.now())
            .compareTo(b.startTime ?? DateTime.now()));

        return quizzes;
      } else {
        throw Exception(
            'Failed to load assigned quizzes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching assigned quizzes: $e'); // Add debug log
      throw Exception('Error fetching assigned quizzes: $e');
    }
  }

  // Get quiz by ID
  Future<Quiz> getQuizById(int quizId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/quizzes/$quizId/'),
        headers: await headers,
      );

      if (response.statusCode == 200) {
        return Quiz.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quiz: $e');
    }
  }

  Future<void> saveStudentAnswer(int questionId, int selectedOptionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Quiz/answers/'),
        headers: await headers,
        body: jsonEncode({
          'question': questionId,
          'selected_option': selectedOptionId,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        print('Error saving answer: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to save answer');
      }
    } catch (e) {
      print('Error saving answer: $e');
      throw Exception('Failed to save answer: $e');
    }
  }

  // Submit quiz
  Future<Map<String, dynamic>> submitQuiz(int quizId,
      {bool isTimeUp = false}) async {
    try {
      print('Submitting quiz: $quizId');

      final response = await http.post(
        Uri.parse('$baseUrl/Quiz/quizzes/$quizId/submit/'),
        headers: await headers,
        body: jsonEncode({
          'is_time_up': isTimeUp,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to submit quiz');
      }
    } catch (e) {
      print('Submit error: $e');
      throw Exception('Failed to submit quiz: $e');
    }
  }
  // ====================== RESULT ENDPOINTS ======================

  // Get quiz history
  Future<List<Result>> getQuizHistory() async {
    try {
      print('Fetching quiz history...'); // Debug log
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/results/'),
        headers: await headers,
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final results = data
            .map((json) {
              try {
                return Result.fromJson(json);
              } catch (e) {
                print('Error parsing individual result: $e');
                return null;
              }
            })
            .where((result) => result != null)
            .cast<Result>()
            .toList();

        print('Successfully parsed ${results.length} results'); // Debug log
        return results;
      } else {
        throw Exception('Failed to load results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getQuizHistory: $e'); // Debug log
      throw Exception('Failed to load results: $e');
    }
  }

  // Get results
  Future<List<Result>> getResults() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/results/'),
        headers: await headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((result) => Result.fromJson(result)).toList();
      } else {
        throw Exception('Failed to load results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load results: $e');
    }
  }

  Future<Map<String, dynamic>> getQuizResult(int quizId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/results/$quizId/'),
        headers: await headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Result not available yet');
      } else {
        throw Exception('Failed to load quiz result');
      }
    } catch (e) {
      throw Exception('Error fetching result: $e');
    }
  }

  Future<Map<String, dynamic>> getQuizDetailedResult(int resultId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Quiz/results/$resultId/detail/'),
      headers: await headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quiz result');
    }
  }
}
