import 'package:ebiapp/screens/LoginScreen.dart';

import '../utils/globals.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserData user;

  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: Column(children: [
        Container(
            child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Sarah')),
                DataCell(Text('19')),
                DataCell(Text('Student')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Janine')),
                DataCell(Text('43')),
                DataCell(Text('Professor')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('William')),
                DataCell(Text('27')),
                DataCell(Text('Associate Professor')),
              ],
            ),
          ],
        )),
      ])),

      // this it the menu bar on the side
      drawer: Container(
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
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            const Divider(
              height: 1,
              thickness: 2,
              color: Colors.black,
            ),
            ListTile(
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
          ],
        ),
      ),
    );
  }
}
