import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class OperationsScreen extends StatefulWidget {
  final UserData user;

  OperationsScreen(this.user);

  @override
  _OperationsScreenState createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
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

  Future<List<Operations>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    List<Operations> foundTables = [];
    for (int i = 0; i < OperationsTable.length; i++) {
      if (OperationsTable[i].po.contains(search) ||
          OperationsTable[i].po == search) {
        foundTables.add(OperationsTable[i]);
      }
    }
    return List.generate(foundTables.length, (int index) {
      return Operations(
        invoiceID: foundTables[index].invoiceID,
        processID: foundTables[index].processID,
        tramitDate: foundTables[index].tramitDate,
        customsID: foundTables[index].customsID,
        customsName: foundTables[index].customsName,
        factoryID: foundTables[index].factoryID,
        clientName: foundTables[index].clientName,
        transportID: foundTables[index].transportID,
        tramitID: foundTables[index].tramitID,
        arrivalDate: foundTables[index].arrivalDate,
        po: foundTables[index].po,
        unit: foundTables[index].unit,
        processDate: foundTables[index].processDate,
        ready: foundTables[index].ready,
        hourReady: foundTables[index].hourReady,
        sequence: foundTables[index].sequence,
        entryDate: foundTables[index].entryDate,
        entryHour: foundTables[index].entryHour,
        localizationID: foundTables[index].localizationID,
        telRadio: foundTables[index].telRadio,
      );
    });
  }

  List<Operations> OperationsTable;

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
                    FutureBuilder<List<Operations>>(
                      future: EBIapi().fetchOperations(widget.user.idcliente),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          OperationsTable = snapshot.data;
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
              onItemFound: (InventoryTable post, int index) {
                return ExpansionTile(
                  key: Key('MainTile'),
                  title: Text(
                    'PO: ${post.po}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
