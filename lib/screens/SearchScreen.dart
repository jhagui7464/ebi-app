import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final UserData user;
  final List<ClientTable> tables;

  SearchScreen(this.user, this.tables);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<ClientTable>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(widget.tables.length, (int index) {
      if (widget.tables[index].po.contains(search)) {
        return widget.tables[index];
      } else {
        return null;
      }
    });
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
      } else if (_selectedIndex == 1) {
        setState(() {});
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SettingsScreen(widget.user, widget.tables)));
      }
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<ClientTable>(
            onSearch: search,
            onItemFound: (ClientTable post, int index) {
              return ExpansionTile(
                key: Key('MainTile'),
                title: Text(
                  'PO: ${post.po}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('Transportation:  ${post.trans}'),
                  ),
                  ListTile(
                    title: Text('Unit:  ${post.unit}'),
                  ),
                  ListTile(
                    title: Text('Origin:  ${post.origin}'),
                  ),
                  ListTile(
                    title: Text('Destination:  ${post.destination}'),
                  ),
                  ListTile(
                    title: Text('Initial Date:  ${post.intDate}'),
                  ),
                  ExpansionTile(
                    title:
                        Text('Unload Date: ' + stringExists(post.unloadDate)),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            'Unload Hour: ' + stringExists(post.unloadHour)),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                        'Delivery Date: ' + trimString(post.deliverDate, 'T')),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            'Delivery Hour: ' + stringExists(post.deliverHour)),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('ETA:  ${post.etaDate}'),
                  ),
                  ListTile(
                    title: Text('Reference:  ${post.refNum}'),
                  ),
                  ListTile(
                    title: Text('Observation:  ${post.observation}'),
                  ),
                  ListTile(
                    title: Text('Comment: ' + commentExists(post.comment)),
                  ),
                ],
              );
            },
          ),
        ),
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
