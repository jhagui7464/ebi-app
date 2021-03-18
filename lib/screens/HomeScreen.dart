import 'package:ebiapp/screens/SearchScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(widget.user),
            ));
      } else if (_selectedIndex == 2) {
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
          Container(
            child: FutureBuilder<List<ClientTable>>(
              future: EBIapi().fetchTables(widget.user.idcliente),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userTables = snapshot.data;
                  return RichText(
                      key: Key('titleScreen'),
                      text: TextSpan(
                          text: 'TRACKING OPERATIONS',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            child: FutureBuilder<List<ClientTable>>(
              future: EBIapi().fetchdoneTables(widget.user.idcliente),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userTables.addAll(snapshot.data);
                  //sortCut(userTables);
                  return Container(
                      child: Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(1),
                      itemCount: userTables.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            color: Colors.grey[300],
                            child: ExpansionTile(
                              key: Key('MainTile'),
                              title: Text(
                                'PO: ${userTables[index].po}',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                      'Transportation:  ${userTables[index].trans}'),
                                ),
                                ListTile(
                                  title:
                                      Text('Unit:  ${userTables[index].unit}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Origin:  ${userTables[index].origin}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Destination:  ${userTables[index].destination}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Initial Date:  ${userTables[index].intDate}'),
                                ),
                                ExpansionTile(
                                  title: Text('Unload Date: ' +
                                      stringExists(
                                          userTables[index].unloadDate)),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Unload Hour: ' +
                                          stringExists(
                                              userTables[index].unloadHour)),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text('Delivery Date: ' +
                                      trimString(
                                          userTables[index].deliverDate, 'T')),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Delivery Hour: ' +
                                          stringExists(
                                              userTables[index].deliverHour)),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  title: Text(
                                      'ETA:  ${userTables[index].etaDate}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Reference:  ${userTables[index].refNum}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Observation:  ${userTables[index].observation}'),
                                ),
                                ListTile(
                                  title: Text('Comment: ' +
                                      commentExists(userTables[index].comment)),
                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(thickness: 0),
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              },
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
