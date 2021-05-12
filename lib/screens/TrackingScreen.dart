import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class TrackingSearchScreen extends StatefulWidget {
  final UserData user;

  TrackingSearchScreen(this.user);

  @override
  _TrackingSearchScreenState createState() => _TrackingSearchScreenState();
}

class _TrackingSearchScreenState extends State<TrackingSearchScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(widget.user)));
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsScreen(widget.user)));
      }
    });
  }

  Color prioCheck(int check) {
    if (check == 1) {
      return Colors.red[300];
    } else
      return Colors.grey[300];
  }

  Future<List<ClientTable>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    List<ClientTable> foundTables = [];
    for (int i = 0; i < userTables.length; i++) {
      if (userTables[i].po.contains(search) || userTables[i].po == search) {
        foundTables.add(userTables[i]);
      }
    }
    return List.generate(foundTables.length, (int index) {
      return ClientTable(
        po: foundTables[index].po,
        trans: foundTables[index].trans,
        unit: foundTables[index].unit,
        origin: foundTables[index].origin,
        destination: foundTables[index].destination,
        intDate: foundTables[index].intDate,
        unloadDate: foundTables[index].unloadDate,
        unloadHour: foundTables[index].unloadHour,
        deliverDate: foundTables[index].deliverDate,
        deliverHour: foundTables[index].deliverHour,
        etaDate: foundTables[index].etaDate,
        refNum: foundTables[index].refNum,
        observation: foundTables[index].observation,
        comment: foundTables[index].comment,
        priority: foundTables[index].priority,
      );
    });
  }

  List<ClientTable> userTables;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFE5251E),
          title: Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Text(
                "Tracking Operations",
                key: Key('tracking-title'),
              )),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            //the icon button let's us pop back to the
            //cup selection screen
            key: Key('goBack'),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(widget.user)));
            },
          )),
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
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return Container();
                      },
                    ),
                    FutureBuilder<List<ClientTable>>(
                      future: EBIapi().fetchdoneTables(widget.user.idcliente),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i < snapshot.data.length; i++) {
                            if (snapshot.data[i].deliverDate != null) {
                              String testDate =
                                  trimString(snapshot.data[i].deliverDate, 'T');

                              if (snapshot.data[i].deliverHour != null) {
                                testDate += ' ';
                                testDate += snapshot.data[i].deliverHour;
                              }
                              DateTime dateTime = DateTime.parse(testDate);
                              Duration dur =
                                  DateTime.now().difference(dateTime);
                              if (dur.inDays < 1) {
                                userTables.add(snapshot.data[i]);
                              }
                            }
                          }
                          return Container(
                              child: Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(1),
                              itemCount: userTables.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    color:
                                        prioCheck(userTables[index].priority),
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
                                              stringExists(userTables[index]
                                                  .unloadDate)),
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
                                              stringExists(trimString(
                                                  userTables[index].deliverDate,
                                                  'T'))),
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
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
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
              }),
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
