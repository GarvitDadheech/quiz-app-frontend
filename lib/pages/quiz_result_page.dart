import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizResultPage extends StatelessWidget {
  final int correctAnswers;
  final int bonusEarned;

  QuizResultPage({required this.correctAnswers, required this.bonusEarned});

  Future<void> updateUserCash(int userId, int bonusEarned) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/update-user-cash'),
      body: json.encode({
        'user_id': userId,
        'bonus_earned': bonusEarned,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user cash');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the function to update user cash
    updateUserCash(1, bonusEarned); // Replace 1 with actual user ID

    return Scaffold(
      backgroundColor: Color(0xFF9370DB),
      appBar: AppBar(
        backgroundColor: Color(0xFF9370DB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 4,
            color: Colors.greenAccent,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/well_done_man.png', height: 150),
                    SizedBox(height: 20),
                    Text(
                      'Well done!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "If you're ready to take your chart analysis into the real world, this award-winning broker is a great place to open a real trading account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildResultCard(
                          icon: '🎯',
                          title: 'Correct answers',
                          value: '$correctAnswers/10',
                        ),
                        _buildResultCard(
                          icon: '🎁',
                          title: 'Bonus earned',
                          value: '\$$bonusEarned',
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                      },
                      child: Text('Done', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({required String icon, required String title, required String value}) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 30)),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.white70)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}