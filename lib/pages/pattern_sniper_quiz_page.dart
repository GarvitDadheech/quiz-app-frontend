import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_drawer_menu.dart';
import 'quiz_question_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternSniperQuizPage extends StatefulWidget {
  @override
  _PatternSniperQuizPageState createState() => _PatternSniperQuizPageState();
}

class _PatternSniperQuizPageState extends State<PatternSniperQuizPage> {
  Future<int> _fetchRecentQuizId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final response =
        await http.get(Uri.parse('http://localhost:8080/recent-quiz/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load recent quiz ID');
    }
  }

  void _startQuiz(BuildContext context) async {
    try {
      final recentQuizId = await _fetchRecentQuizId();
      final newQuizId = recentQuizId + 1;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuizQuestionPage(quizId: newQuizId)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load the quiz ID: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Pattern Sniper™ Quiz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Improve your pattern recognition skills through interactive quizzes on technical and fundamental analysis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              SizedBox(height: 30),
              Card(
                color: Color(0xFF8A2BE2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.show_chart, color: Colors.greenAccent),
                  title: Text(
                    'Learn technical analysis',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Try to determine the price moves by analyzing real historical chart patterns and indicators.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF8A2BE2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading:
                      Icon(Icons.account_balance, color: Colors.greenAccent),
                  title: Text(
                    'Master fundamental analysis',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Discover how macroeconomics, politics, and news influence various assets.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Color(0xFF8A2BE2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.assessment, color: Colors.greenAccent),
                  title: Text(
                    'Test your knowledge',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Assess and improve your knowledge of various theoretical terms.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: ElevatedButton(
                  onPressed: () => _startQuiz(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00C18E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Let's go",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
