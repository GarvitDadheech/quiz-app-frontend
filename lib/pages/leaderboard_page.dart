import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_drawer_menu.dart';
class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    final response = await http.get(Uri.parse('http://localhost:8080/leaderboard'));
    if (response.statusCode == 200) {
      setState(() {
        leaderboard = (json.decode(response.body) as List).map((user) {
          return {
            'username': user['username'],
            'cash': user['cash'] is int ? (user['cash'] as int).toDouble() : user['cash'],
          };
        }).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: Color(0xFF9370DB), // Light purple background
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 28, 
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: leaderboard.length,
                      itemBuilder: (context, index) {
                        final user = leaderboard[index];
                        return LeaderboardTile(
                          rank: index + 1,
                          username: user['username'],
                          cash: user['cash'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String username;
  final double cash;

  LeaderboardTile({
    required this.rank,
    required this.username,
    required this.cash,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: rank == 1
          ? Colors.amber[300]
          : rank == 2
              ? Colors.grey[400]
              : rank == 3
                  ? Colors.brown[300]
                  : Color(0xFF9370DB), // Use purple background for other ranks
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Color(0xFF9370DB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${cash.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
