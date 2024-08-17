import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<double> fetchUserCash() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('User ID not found. Please log in again.');
    }

    final response = await http.get(Uri.parse('http://localhost:8080/user-cash/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cash_amount'] as num).toDouble();;
    } else {
      throw Exception('Failed to load user cash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF9370DB),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      centerTitle: true,
      title: FutureBuilder<double>(
        future: fetchUserCash(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Colors.white);
          } else if (snapshot.hasError) {
            return Text('Error', style: TextStyle(fontSize: 24, color: Colors.white));
          } else {
            return Text(
              '\$${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(fontSize: 24, color: Colors.white),
            );
          }
        },
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text('PRO', style: TextStyle(color: Colors.white)),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }
}
