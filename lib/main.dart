import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF9370DB), // Light purple background
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('\$112,000.00',
            style: TextStyle(fontSize: 24, color: Colors.white)),
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
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Image.asset('assets/cartoon_image.png', height: 150),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8A2BE2), // Darker purple
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
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Trade'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF9370DB), // Light purple background
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00C18E), // Follow us button color
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
              title: Text('Share this app', style: TextStyle(color: Colors.white)),
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
              title: Text('Reset account', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
              title: Text('Delete account', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.login, color: Colors.white),
              title: Text('Login', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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


