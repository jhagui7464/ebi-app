import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final UserData user;

  SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
      } else if (_selectedIndex == 1) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(widget.user)));
        });
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsScreen(widget.user)));
      }
    });
  }

  Future<List<ClientTable>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(userTables.length, (int index) {
      if (userTables[index].po.contains(search) ||
          userTables[index].po == search) {
        return ClientTable(
          po: userTables[index].po,
          trans: userTables[index].trans,
          unit: userTables[index].unit,
          origin: userTables[index].origin,
          destination: userTables[index].destination,
          intDate: userTables[index].intDate,
          unloadDate: userTables[index].unloadDate,
          unloadHour: userTables[index].unloadHour,
          deliverDate: userTables[index].deliverDate,
          deliverHour: userTables[index].deliverHour,
          etaDate: userTables[index].etaDate,
          refNum: userTables[index].refNum,
          observation: userTables[index].observation,
          comment: userTables[index].comment,
        );
      } else
        return null;
    });
  }

  List<ClientTable> userTables;

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
            hintText: "Search by PO",
            hintStyle: TextStyle(
              color: Colors.black54,
            ),
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            loader: Center(
              child: CircularProgressIndicator(),
            ),
            placeHolder: Center(
              child: Column(
                children: [
                  FutureBuilder<List<ClientTable>>(
                    future: EBIapi().fetchTables(widget.user.idcliente),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        userTables = snapshot.data;
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      return Container();
                    },
                  ),
                  FutureBuilder<List<ClientTable>>(
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
                                        title: Text(
                                            'Unit:  ${userTables[index].unit}'),
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
                                                stringExists(userTables[index]
                                                    .unloadHour)),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('Delivery Date: ' +
                                            trimString(
                                                userTables[index].deliverDate,
                                                'T')),
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('Delivery Hour: ' +
                                                stringExists(userTables[index]
                                                    .deliverHour)),
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
                                            commentExists(
                                                userTables[index].comment)),
                                      ),
                                    ],
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(thickness: 0),
                          ),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
            onError: (error) {
              return Center(
                child: Text("Error occurred : $error"),
              );
            },
            emptyWidget: Center(
              child: Text("Empty"),
            ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            minimumChars: 1,
            onSearch: search,
            onItemFound: (ClientTable post, int index) {
              if (post == null) {
                return Container();
              } else {
                return ExpansionTile(
                  key: Key('MainTile'),
                  title: Text(
                    'PO: ${post.po}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                      title: Text('Delivery Date: ' +
                          trimString(post.deliverDate, 'T')),
                      children: <Widget>[
                        ListTile(
                          title: Text('Delivery Hour: ' +
                              stringExists(post.deliverHour)),
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
              }
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
