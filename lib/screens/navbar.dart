import 'package:flutter/material.dart';
import 'package:journal_app/screens/homescreen.dart';
import 'package:journal_app/screens/profilescreen.dart';
import 'package:journal_app/services/auth.dart';


class NavBar extends StatefulWidget {
  final AuthMethods auth;
  const NavBar({super.key, required this.auth});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    final List<Widget> _pages = <Widget>[
      HomeScreen(auth: widget.auth),
      ProfileScreen(auth: widget.auth),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

