import 'package:ebiapp/screens/InventoryScreen.dart';
import 'package:ebiapp/screens/TrackingScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/screens/OperationsScreen.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserData user;

  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ClientTable> userTables;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        setState(() {});
      } else if (_selectedIndex == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(widget.user),
              ));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFE5251E),
        title: Text(
          "Welcome, ${widget.user.uname}",
          key: Key('welcome'),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Divider(),
          Text(
            "Main Menu",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Divider(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: 350,
              color: Colors.grey[200],
              child: ListTile(
                key: Key("tracking-button"),
                title: Text(
                  "Tracking",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TrackingSearchScreen(widget.user)));
                },
              ),
            ),
          ),
          Divider(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: 350,
              color: Colors.grey[200],
              child: ListTile(
                key: Key("inventory-button"),
                title: Text(
                  "Inventory",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InventoryScreen(widget.user)));
                },
              ),
            ),
          ),
          Divider(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: 350,
              color: Colors.grey[200],
              child: ListTile(
                key: Key("operations-button"),
                title: Text(
                  "Operations",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InventoryScreen(widget.user)));
                },
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
