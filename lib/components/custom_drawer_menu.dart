import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login.dart';

class CustomDrawer extends StatelessWidget {
  Future<void> _deleteUserAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found.')),
      );
      return;
    }

    final url = 'http://localhost:8080/delete-user/$userId';
    final response = await http.delete(Uri.parse(url));
  
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully.')),
      );
      await prefs.remove('userId');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account.')),
      );
    }
  }

  Future<void> _navigateToLoginPage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF9370DB),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF9370DB),
              ),
              child: Column(
                children: [
                  Image.asset('assets/cartoon_image.png', height: 80),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      const url =
                          'https://www.instagram.com/threeinvesteers/?hl=en';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00C18E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Follow us on Instagram'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title:
                  Text('Share this app', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.white),
              title: Text('Rate us', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.mail, color: Colors.white),
              title: Text('Contact us', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: Colors.white),
              title:
                  Text('Reset account', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
              title:
                  Text('Delete account', style: TextStyle(color: Colors.white)),
              onTap: () {
                _deleteUserAccount(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.login, color: Colors.white),
              title: Text('Login', style: TextStyle(color: Colors.white)),
              onTap: () {
                _navigateToLoginPage(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.white),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                  Text('Terms of Use', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
