import 'package:flutter/material.dart';

class CommonPage extends StatelessWidget {
  final String message;
  final String emoji;

  CommonPage({
    this.message = "To be implemented soon. Sorry for the inconvenience.",
    this.emoji = "😔",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9370DB), // Purple background
      appBar: AppBar(
        title: Text("Under Construction"),
        backgroundColor: Color(0xFF9370DB),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 100), // Large emoji
            ),
            SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
