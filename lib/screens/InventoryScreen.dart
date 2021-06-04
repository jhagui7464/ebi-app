import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  final UserData user;

  InventoryScreen(this.user);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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

  Future<List<InventoryTable>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    List<InventoryTable> foundTables = [];
    for (int i = 0; i < invTables.length; i++) {
      if (invTables[i].po.contains(search) || invTables[i].po == search) {
        foundTables.add(invTables[i]);
      }
    }
    return List.generate(foundTables.length, (int index) {
      return InventoryTable(
        po: foundTables[index].po,
        tramitID: foundTables[index].tramitID,
        dateArrived: foundTables[index].dateArrived,
        factoryID: foundTables[index].factoryID,
        bulkNumber: foundTables[index].bulkNumber,
        productPounds: foundTables[index].productPounds,
        productID: foundTables[index].productID,
        productDescription: foundTables[index].productDescription,
        totalExits: foundTables[index].totalExits,
        existence: foundTables[index].existence,
      );
    });
  }

  Widget _searchWidget(BuildContext context) {
    return new SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SearchBar<InventoryTable>(
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
                  FutureBuilder<List<InventoryTable>>(
                    future:
                        EBIapi().fetchInventoryTables(widget.user.idcliente),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        invTables = snapshot.data;
                        return Container(
                            child: Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(1),
                            itemCount: invTables.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  color: Colors.grey[300],
                                  child: ExpansionTile(
                                    key: Key('MainTile'),
                                    title: Text(
                                      'PO: ${invTables[index].po}',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Transportation: ' +
                                            stringExists(invTables[index]
                                                .tramitID
                                                .toString())),
                                      ),
                                      ListTile(
                                        title: Text('Date Arrived: ' +
                                            commentExists(trimString(
                                                invTables[index]
                                                    .dateArrived
                                                    .toString(),
                                                'T'))),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Product:  ${invTables[index].productDescription}'),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Weight:  ${invTables[index].productPounds}'),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Total Cases:  ${invTables[index].bulkNumber}'),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Total Shipments: ${invTables[index].totalExits}'),
                                      ),
                                      ListTile(
                                        title: Text(
                                            'Remaining:  ${invTables[index].existence}'),
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
            onItemFound: (InventoryTable post, int index) {
              return ExpansionTile(
                key: Key('MainTile'),
                title: Text(
                  'PO: ${post.po}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('Transportation:  ${post.tramitID}'),
                  ),
                  ListTile(
                    title: Text('Unit:  ${post.dateArrived}'),
                  ),
                  ListTile(
                    title: Text('Origin:  ${post.productDescription}'),
                  ),
                  ListTile(
                    title: Text('Destination:  ${post.productPounds}'),
                  ),
                  ListTile(
                    title: Text('Initial Date:  ${post.bulkNumber}'),
                  ),
                  ListTile(
                    title: Text('ETA:  ${post.totalExits}'),
                  ),
                  ListTile(
                    title: Text('Reference:  ${post.existence}'),
                  ),
                ],
              );
            }),
      ),
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

  List<InventoryTable> invTables;

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
                "Inventory Operations",
                key: Key('inventory-title'),
              )),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            key: Key('goBack'),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => HomeScreen(widget.user)));
            },
          )),
      body: _searchWidget(context),
      bottomNavigationBar: bottomMenu(context),
    );
  }
}
