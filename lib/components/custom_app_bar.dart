import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

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
      title: Text(
        '\$112,000.00',
        style: TextStyle(fontSize: 24, color: Colors.white),
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
        preferredSize: Size.fromHeight(1.0), // Height of the line
        child: Container(
          color: Colors.white, // Color of the line
          height: 1.0, // Height of the line
        ),
      ),
    );
  }
}
