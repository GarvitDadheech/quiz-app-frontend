import 'package:flutter/material.dart';
import '../pages/homepage.dart'; // Import the HomePage widget
import '../pages/implement_soon_page.dart'; // Import the CommonPage widget

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // Default index
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
          case 2:
          case 3:
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonPage(),
              ),
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet), label: 'Portfolio'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Trade'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
      ],
    );
  }
}
