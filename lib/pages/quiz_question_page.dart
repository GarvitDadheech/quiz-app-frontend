import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'quiz_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizQuestionPage extends StatefulWidget {
  final int quizId;

  QuizQuestionPage({required this.quizId});

  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswerSubmitted = false;
  bool isAnswerCorrect = false;
  int correctAnswersCount = 0;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    fetchUserId();
    _startTimer();
  }

  Future<void> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  Future<void> fetchQuestions() async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/quiz/${widget.quizId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        questions = List<Map<String, dynamic>>.from(data['questions']);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future submitAnswer() async {
    if (selectedAnswerIndex == null) return;
  
    final response = await http.post(
      Uri.parse('http://localhost:8080/submit-answer'),
      body: json.encode({
        'user_id': userId,
        'quiz_id': widget.quizId,
        'question_id': questions[currentQuestionIndex]['id'],
        'answer_id': questions[currentQuestionIndex]['answers']
            [selectedAnswerIndex!]['id'],
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        isAnswerSubmitted = true;
        isAnswerCorrect = data['correct'];
        if (data['correct']) {
          correctAnswersCount++;
        }
      });
    } else {
      throw Exception('Failed to submit answer');
    }
  }

  Future<void> updateRecentQuizAttempt(int quizId) async {
    final url = 'http://localhost:8080/update-recent-quiz';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'quiz_id': quizId,
      }),
    );

    if (response.statusCode == 200) {
      print('Quiz attempt updated successfully');
    } else {
      print('Failed to update quiz attempt: ${response.statusCode}');
    }
  }

  void nextQuestion() async {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswerSubmitted = false;
      });
    } else {
      await updateRecentQuizAttempt(widget.quizId);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizResultPage(
            correctAnswers: correctAnswersCount,
            bonusEarned: correctAnswersCount * 1000,
            timeTaken: _formatTime(_elapsedSeconds),
            currentQuizId: widget.quizId,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF9370DB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                _formatTime(_elapsedSeconds),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${questions.length}',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    questions[currentQuestionIndex]['question'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...(questions[currentQuestionIndex]['answers'] as List)
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              child: Text(entry.value['answer'],
                                  style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedAnswerIndex ==
                                        entry.key
                                    ? (isAnswerSubmitted
                                        ? (isAnswerCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Color(
                                            0xFFB39DDB)) 
                                    : Colors.white,
                                minimumSize:
                                    Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: isAnswerSubmitted
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedAnswerIndex = entry.key;
                                      });
                                    },
                            ),
                          ))
                      .toList(),
                  SizedBox(height: 20),
                  if (isAnswerSubmitted)
                    Center(
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.transparent,
                          end: isAnswerCorrect ? Colors.green : Colors.red,
                        ),
                        duration: Duration(seconds: 1),
                        builder: (context, color, child) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color!, width: 2),
                            ),
                            child: Text(
                              '${isAnswerCorrect ? 'Correct Answer! 🥳' : 'Wrong Answer! 😞'}',
                              style: TextStyle(
                                color: color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text(
                  isAnswerSubmitted ? 'Explanation' : 'Extra Hint',
                  style: TextStyle(color: Color(0xFF9370DB)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(120, 60),
                  side: BorderSide(color: Color(0xFF9370DB), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Show hint or explanation
                },
              ),
              ElevatedButton(
                child: Text(
                  isAnswerSubmitted ? 'Continue' : 'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  minimumSize: Size(120, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: selectedAnswerIndex != null
                    ? (isAnswerSubmitted ? nextQuestion : submitAnswer)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
