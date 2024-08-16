import 'package:flutter/material.dart';
import '../pages/homepage.dart'; // Import the HomePage widget

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
          // Handle other tabs if needed
          case 1:
            // Navigate to Portfolio page
            break;
          case 2:
            // Navigate to Trade page
            break;
          case 3:
            // Navigate to Profile page
            break;
          case 4:
            // Navigate to Leaderboard page
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
