import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/LoginScreen.dart';
import 'package:ebiapp/screens/SearchScreen.dart';
import 'package:ebiapp/utils/globals.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final UserData user;
  SettingsScreen(this.user);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void initState() {
    super.initState();
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SearchScreen(widget.user)));
      } else if (_selectedIndex == 2) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsScreen(widget.user)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFE5251E),
        title: Text(
          "Settings",
          key: Key('settings'),
        ),
      ),
      body: Center(
        child: Container(
            color: Colors.white,
            child: Card(
              child: ListTile(
                key: Key('log-out'),
                title: Text('Logout'),
                onTap: () {
                  // Update the state of the app
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  });
                },
              ),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: Key('bottom-bar'),
        backgroundColor: Color(0xFFE5251E),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
