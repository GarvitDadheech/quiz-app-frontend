import 'package:flutter/material.dart';
import 'pattern_sniper_quiz_page.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_drawer_menu.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(), 
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset('assets/cartoon_image.png', height: 150),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8A2BE2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.track_changes, color: Colors.teal),
                title: Text('Pattern Sniper™ Quiz',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text('Practice technical & fundamental analysis',
                    style: TextStyle(color: Colors.white70)),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('NEW', style: TextStyle(color: Colors.white)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatternSniperQuizPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

