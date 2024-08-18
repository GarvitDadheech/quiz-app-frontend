import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _usernameFuture;
  late Future<Map<String, dynamic>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _fetchUsername();
    _badgesFuture = _fetchBadges();
  }

  Future<String> _fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final response = await http.get(Uri.parse('http://localhost:8080/user/$userId/username'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['username'];
    } else {
      throw Exception('Failed to load username');
    }
  }

  Future<Map<String, dynamic>> _fetchBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final response = await http.get(Uri.parse('http://localhost:8080/user/$userId/badges'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception('Failed to load badges');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 226, 196, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: _usernameFuture,
          builder: (context, usernameSnapshot) {
            if (usernameSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (usernameSnapshot.hasError) {
              return Center(child: Text('Error: ${usernameSnapshot.error}'));
            } else if (!usernameSnapshot.hasData || usernameSnapshot.data!.isEmpty) {
              return Center(child: Text('Failed to load username.'));
            } else {
              String username = usernameSnapshot.data!;
              return FutureBuilder<Map<String, dynamic>>(
                future: _badgesFuture,
                builder: (context, badgesSnapshot) {
                  if (badgesSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (badgesSnapshot.hasError) {
                    return Center(child: Text('Error: ${badgesSnapshot.error}'));
                  } else if (!badgesSnapshot.hasData || badgesSnapshot.data!.isEmpty) {
                    return Center(child: Text('No badges available.'));
                  } else {
                    Map<String, dynamic> badges = badgesSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hey $username,',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Badges Earned',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: badges.keys.length,
                            itemBuilder: (context, index) {
                              final badgeName = badges.keys.elementAt(index);
                              final badge = badges[badgeName];
                              return BadgeCard(
                                name: badgeName,
                                description: badge['description'],
                                earned: badge['earned'],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class BadgeCard extends StatelessWidget {
  final String name;
  final String description;
  final bool earned;

  BadgeCard({required this.name, required this.description, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Icon(
          earned ? Icons.check_circle : Icons.cancel,
          color: earned ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
