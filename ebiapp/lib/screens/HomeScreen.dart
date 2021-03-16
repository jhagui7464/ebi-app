import 'package:ebiapp/screens/LoginScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';

import '../utils/globals.dart';
import 'package:flutter/material.dart';

//import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HomeScreen extends StatefulWidget {
  final UserData user;

  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ClientTable> userTables;

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
          key: Key('welcome '),
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
                  return Container(
                      child: Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(1),
                      itemCount: userTables.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                          key: Key('MainTile'),
                          title: Text(
                            'PO: ${userTables[index].po}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  'Transportation:  ${userTables[index].trans}'),
                            ),
                            ListTile(
                              title: Text('Unit:  ${userTables[index].unit}'),
                            ),
                            ListTile(
                              title:
                                  Text('Origin:  ${userTables[index].origin}'),
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
                                  stringExists(userTables[index].unloadDate)),
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
                              title: Text('ETA:  ${userTables[index].etaDate}'),
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
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(thickness: 5),
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
      // this it the menu bar on the side
      drawer: Container(
        key: Key('hamburger-menu'),
        width: 200,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150.0,
              child: DrawerHeader(
                child: Image.asset(
                  'assets/images/ebi_02.png',
                  height: 200,
                  width: 200,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFbd3038),
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 9,
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(
              height: 1,
              thickness: 3,
              color: Colors.black,
            ),
            Container(
              color: Colors.white,
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
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
