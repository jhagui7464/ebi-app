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
        transportName: foundTables[index].transportName,
        tramitID: foundTables[index].tramitID,
        arrivalDate: foundTables[index].arrivalDate,
        po: foundTables[index].po,
        unit: foundTables[index].unit,
        processDate: foundTables[index].processDate,
        ready: foundTables[index].ready,
        hourReady: foundTables[index].hourReady,
        timeChain: foundTables[index].timeChain,
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
                "Panel of Operations",
                key: Key('operations-title'),
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
          child: SearchBar<Operations>(
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
                      future:
                          EBIapi().fetchDoneOperations(widget.user.idcliente),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          OperationsTable = snapshot.data;
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return Container();
                      },
                    ),
                    FutureBuilder<List<Operations>>(
                      future: EBIapi().fetchOperations(widget.user.idcliente),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i < snapshot.data.length; i++) {
                            OperationsTable.add(snapshot.data[i]);
                          }
                          if (OperationsTable != null &&
                              OperationsTable.length != 0) {
                            return Container(
                                child: Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(1),
                                itemCount: OperationsTable.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                      color: Colors.grey[300],
                                      child: ExpansionTile(
                                        key: Key('MainTile'),
                                        title: Text(
                                          'PO: ${OperationsTable[index].po}',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('Invoice: ' +
                                                stringExists(
                                                    OperationsTable[index]
                                                        .invoiceID
                                                        .toString())),
                                          ),
                                          ListTile(
                                              title: Text('Tramit Date: ' +
                                                  commentExists(trimString(
                                                      OperationsTable[index]
                                                          .tramitDate
                                                          .toString(),
                                                      'T')))),
                                          ListTile(
                                              title: Text(
                                                  'Customs Name:  ${OperationsTable[index].customsName}')),
                                          ListTile(
                                              title: Text(
                                                  'Client: ${OperationsTable[index].clientName}')),
                                          ListTile(
                                              title: Text(
                                                  'Transport Name: ${OperationsTable[index].transportName}')),
                                          ListTile(
                                              title: Text('Arrival Date: ' +
                                                  commentExists(trimString(
                                                      OperationsTable[index]
                                                          .arrivalDate
                                                          .toString(),
                                                      'T')))),
                                          ListTile(
                                              title: Text(
                                                  'Unit: ${OperationsTable[index].unit}')),
                                          ListTile(
                                              title: Text('Process Date: ' +
                                                  commentExists(trimString(
                                                      OperationsTable[index]
                                                          .processDate
                                                          .toString(),
                                                      'T')))),
                                          ExpansionTile(title: Text('test')),
                                          ListTile(
                                              title: Text('Ready: ' +
                                                  readyCheck(
                                                      OperationsTable[index]
                                                          .ready))),
                                        ],
                                      ));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(thickness: 0),
                              ),
                            ));
                          } else {
                            return Text('no data available at this moment');
                          }
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
              onItemFound: (Operations post, int index) {
                return ExpansionTile(
                  key: Key('MainTile'),
                  title: Text(
                    'PO: ${post.po}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text('Invoice: ' +
                          stringExists(
                              OperationsTable[index].invoiceID.toString())),
                    ),
                    ListTile(
                        title: Text('Tramit Date: ' +
                            commentExists(trimString(
                                OperationsTable[index].tramitDate.toString(),
                                'T')))),
                    ListTile(
                        title: Text(
                            'Customs Name:  ${OperationsTable[index].customsName}')),
                    ListTile(
                        title: Text(
                            'Client: ${OperationsTable[index].clientName}')),
                    ListTile(
                        title: Text(
                            'Transport Name: ${OperationsTable[index].transportName}')),
                    ListTile(
                        title: Text('Arrival Date: ' +
                            commentExists(trimString(
                                OperationsTable[index].arrivalDate.toString(),
                                'T')))),
                    ListTile(
                        title: Text('Unit: ${OperationsTable[index].unit}')),
                    ListTile(
                        title: Text('Process Date: ' +
                            commentExists(trimString(
                                OperationsTable[index].processDate.toString(),
                                'T')))),
                    ListTile(
                        title: Text('Ready: ' +
                            readyCheck(OperationsTable[index].ready))),
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
