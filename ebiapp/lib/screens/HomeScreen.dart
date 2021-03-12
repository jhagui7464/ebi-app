import 'package:ebiapp/screens/LoginScreen.dart';

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
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'PO',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'L. Transport',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unit',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Origin',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Destination',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Start Date',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unload Date',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Delivered Date',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ETA',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Observations',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Comments',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'H',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                    DataCell(Text('Test')),
                  ],
                ),
              ],
            )),
      ])),

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
