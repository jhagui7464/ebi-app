import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/LoginScreen.dart';
import 'package:ebiapp/utils/globals.dart';
import 'package:flutter/cupertino.dart';
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

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => HomeScreen(widget.user)));
      } else if (_selectedIndex == 1) {
        setState(() {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => SettingsScreen(widget.user)));
        });
      }
    });
  }

  Widget _settingsWidget(BuildContext context) {
    return new Center(
      child: Column(children: [
        Container(
            color: Colors.grey[200],
            child: Card(
              child: ListTile(
                key: Key('log-out'),
                title: Text('Logout'),
                trailing: Icon(Icons.keyboard_arrow_right),
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
      ]),
    );
  }

  Widget bottomMenu(BuildContext context) {
    return new BottomNavigationBar(
      key: Key('bottom-bar'),
      backgroundColor: Color(0xFFE5251E),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            key: Key('goBack'),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: _settingsWidget(context),
      bottomNavigationBar: bottomMenu(context),
    );
  }
}
