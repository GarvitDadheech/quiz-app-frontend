import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class QuizResultPage extends StatefulWidget {
  final int correctAnswers;
  final int bonusEarned;
  final String timeTaken;
  final int currentQuizId;

  QuizResultPage({
    required this.correctAnswers,
    required this.bonusEarned,
    required this.timeTaken,
    required this.currentQuizId,
  });

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  List<int> earnedBadgeIds = [];
  Map<int, String> badgeNames = {};

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
  try {
    await updateUserCash(widget.bonusEarned);
    final badgeIds = await updateBadges();
    final names = await fetchBadgeNames(badgeIds);
    setState(() {
      earnedBadgeIds = badgeIds;
      badgeNames = names;
    });
  } catch (e) {
    print(e.toString());
  }
}

  Future<double> fetchCurrentCash() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found. Please log in again.');
    }

    final response = await http.get(Uri.parse('http://localhost:8080/user-cash/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cash_amount'] as num).toDouble();
    } else {
      throw Exception('Failed to load current cash amount');
    }
  }

  Future<void> updateUserCash(int bonusEarned) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found. Please log in again.');
    }

    final currentCash = await fetchCurrentCash();
    final newCashAmount = currentCash + bonusEarned;

    final response = await http.post(
      Uri.parse('http://localhost:8080/update-user-cash'),
      body: json.encode({
        'user_id': userId,
        'cash_amount': newCashAmount,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user cash');
    }
  }

  Future<List<int>> updateBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found. Please log in again.');
    }

    List<int> badgeIds = [];

    if (widget.correctAnswers >= 9) badgeIds.add(2);
    if (widget.currentQuizId == 3) badgeIds.add(1);
    if (widget.correctAnswers == 10) badgeIds.add(3);
    if (widget.timeTaken.contains(RegExp(r'^([0-2][0-9]|30):([0-5][0-9])$')) && widget.correctAnswers == 8) badgeIds.add(4);

    final response = await http.post(
      Uri.parse('http://localhost:8080/update-user-badges'),
      body: json.encode({
        'user_id': userId,
        'badge_ids': badgeIds,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update badges');
    }

    return badgeIds; // Return the list of badge IDs
  }

  Future<Map<int, String>> fetchBadgeNames(List<int> badgeIds) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/get-badge-names'),
    body: json.encode({'badge_ids': badgeIds}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final badgeNamesJson = data['badge_names'] as Map<String, dynamic>; // Ensure correct type
    final badgeNames = badgeNamesJson.map<int, String>((key, value) {
      return MapEntry(int.parse(key), value as String);
    });
    return badgeNames;
  } else {
    throw Exception('Failed to fetch badge names');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9370DB),
      appBar: AppBar(
        backgroundColor: Color(0xFF9370DB),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
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
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "If you're ready to take your chart analysis into the real world, this award-winning broker is a great place to open a real trading account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 30),
                    _buildBadgeAndResults(),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage()), // Redirect to HomePage
                          (Route<dynamic> route) =>
                              false, // Remove all previous routes
                        );
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

  Widget _buildBadgeAndResults() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildResultCard(
              icon: '🎯',
              title: 'Correct answers',
              value: '${widget.correctAnswers}/10',
            ),
            _buildResultCard(
              icon: '🎁',
              title: 'Bonus earned',
              value: '\$${widget.bonusEarned}',
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildResultCard(
              icon: '⏱️',
              title: 'Time taken',
              value: widget.timeTaken,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: earnedBadgeIds.map((badgeId) {
            return _buildBadgeCard(badgeId: badgeId);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBadgeCard({required int badgeId}) {
  final badgeName = badgeNames[badgeId] ?? 'Badge $badgeId'; 
  return Container(
    width: 120, 
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.greenAccent, width: 2),
    ),
    child: Column(
      children: [
        Icon(Icons.emoji_events, size: 40, color: Colors.yellowAccent),
        SizedBox(height: 10),
        Text(
          'Congrats!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'You have earned a new badge:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),
        Text(
          badgeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildResultCard(
      {required String icon, required String title, required String value}) {
    return Container(
      width: 100, // Adjust width as needed
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
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
