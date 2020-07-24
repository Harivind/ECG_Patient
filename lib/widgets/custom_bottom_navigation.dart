import 'package:flutter/material.dart';
import 'package:patient/screens/account_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  var selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedItem,
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Account'),
          icon: Icon(Icons.person_outline),
        ),
      ],
      elevation: 0,
      onTap: (value) {
        if (value == 1) {
          Navigator.pushNamed(context, AccountScreen.id);
        }
        setState(() {
          selectedItem = value;
          print(selectedItem);
        });
      },
    );
  }
}
