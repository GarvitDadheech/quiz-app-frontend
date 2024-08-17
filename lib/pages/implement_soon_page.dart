import 'package:flutter/material.dart';

class CommonPage extends StatelessWidget {
  final String message;
  final String emoji;

  CommonPage({
    this.message = "To be implemented soon.",
    this.emoji = "😔",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 167, 126, 249), // Purple background
      appBar: AppBar(
        title: Text("Under Construction"),
        backgroundColor: Color.fromARGB(255, 251, 251, 251),
        elevation: 8,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 200), // Large emoji
            ),
            SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
