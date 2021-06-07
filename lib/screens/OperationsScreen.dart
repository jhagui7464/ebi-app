import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/SettingScreen.dart';
import 'package:ebiapp/utils/ebiAPI.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
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
    _selectedIndex = index;
    if (_selectedIndex == 0) {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => HomeScreen(widget.user)),
            (Route<dynamic> route) => false);
      });
    } else if (_selectedIndex == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    } else if (_selectedIndex == 2) {
      setState(() {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SettingsScreen(widget.user)));
      });
    }
  }

  Future<List<Operations>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    List<Operations> foundTables = [];
    for (int i = 0; i < operationsTable.length; i++) {
      if (operationsTable[i].po.contains(search) ||
          operationsTable[i].po == search) {
        foundTables.add(operationsTable[i]);
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

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: Center(child: Text('All Operations')),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            tileColor: statusCheck(1),
            title: Center(
                child: Text('In Process: ' +
                    commentExists(howManyOperations(operationsTable, 1)))),
          ),
          ListTile(
            tileColor: statusCheck(2),
            title: Center(
                child: Text('Crossing: ' +
                    commentExists(howManyOperations(operationsTable, 2)))),
          ),
          ListTile(
            tileColor: statusCheck(3),
            title: Center(
                child: Text('Divided: ' +
                    commentExists(howManyOperations(operationsTable, 3)))),
          ),
          ListTile(
            tileColor: statusCheck(4),
            title: Center(
                child: Text('Stored: ' +
                    commentExists(howManyOperations(operationsTable, 4)))),
          ),
          ListTile(
            tileColor: statusCheck(5),
            title: Center(
                child: Text('Canceled: ' +
                    commentExists(howManyOperations(operationsTable, 5)))),
          ),
          ListTile(
            tileColor: statusCheck(6),
            title: Center(
                child: Text('Left: ' +
                    commentExists(howManyOperations(operationsTable, 6)))),
          ),
          ListTile(
            tileColor: statusCheck(7),
            title: Center(
                child: Text('Inspecting: ' +
                    commentExists(howManyOperations(operationsTable, 7)))),
          ),
          ListTile(
            title: Center(
                child: Text('Total: ' +
                    commentExists(operationsTable.length.toString()))),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _searchWidget(BuildContext context) {
    return new SafeArea(
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
                    future: EBIapi().fetchDoneOperations(widget.user.idcliente),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        operationsTable = snapshot.data;
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      return Container();
                    },
                  ),
                  FutureBuilder<List<Operations>>(
                    future: EBIapi().fetchOperations(widget.user.idcliente),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++) {
                          operationsTable.add(snapshot.data[i]);
                        }
                        if (operationsTable != null &&
                            operationsTable.length != 0) {
                          return Container(
                              child: Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(1),
                              itemCount: operationsTable.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    color: statusCheck(
                                        operationsTable[index].processID),
                                    child: ExpansionTile(
                                      key: Key('MainTile'),
                                      title: Text(
                                        'PO: ${operationsTable[index].po}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('Invoice: ' +
                                              stringExists(
                                                  operationsTable[index]
                                                      .invoiceID
                                                      .toString())),
                                        ),
                                        ListTile(
                                            title: Text('Tramit Date: ' +
                                                commentExists(trimString(
                                                    operationsTable[index]
                                                        .tramitDate
                                                        .toString(),
                                                    'T')))),
                                        ListTile(
                                            title: Text(
                                                'Customs Name:  ${operationsTable[index].customsName}')),
                                        ListTile(
                                            title: Text(
                                                'Client: ${operationsTable[index].clientName}')),
                                        ListTile(
                                            title: Text(
                                                'Transport Name: ${operationsTable[index].transportName}')),
                                        ListTile(
                                            title: Text('Arrival Date: ' +
                                                commentExists(trimString(
                                                    operationsTable[index]
                                                        .arrivalDate
                                                        .toString(),
                                                    'T')))),
                                        ListTile(
                                            title: Text(
                                                'Unit: ${operationsTable[index].unit}')),
                                        ListTile(
                                            title: Text('Process Date: ' +
                                                commentExists(trimString(
                                                    operationsTable[index]
                                                        .processDate
                                                        .toString(),
                                                    'T')))),
                                        ExpansionTile(
                                          title: Text('Time Chain'),
                                          children: [
                                            ListTile(
                                                title: Text('Received',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[0]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[0]
                                                        [2]))),
                                            ListTile(
                                                title: Text(
                                                    'Documents to Client',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[1]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[1]
                                                        [2]))),
                                            ListTile(
                                                title: Text(
                                                    'Documents from Client',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[2]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[2]
                                                        [2]))),
                                            ListTile(
                                                title: Text('US Inspection',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[3]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[3]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Agency',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[4]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[4]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Transfer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[5]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[5]
                                                        [2]))),
                                            ListTile(
                                                title: Text('PO Requested',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[6]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[6]
                                                        [2]))),
                                            ListTile(
                                                title: Text('PO Received',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[7]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[7]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Transferred',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[8]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[8]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Bodega Exit',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[9]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[9]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Customs Entrance',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[10]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[10]
                                                        [2]))),
                                            ListTile(
                                                title: Text('Customs Exit',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[11]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[11]
                                                        [2]))),
                                            ListTile(
                                                title: Text(
                                                    'Point of Inspection Entrance',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[12]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[12]
                                                        [2]))),
                                            ListTile(
                                                title: Text(
                                                    'Point of Inspection Exit',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            ListTile(
                                                title: Text('Date: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[13]
                                                        [1]))),
                                            ListTile(
                                                title: Text('Hour: ' +
                                                    stringExists(timeChainBreak(
                                                            operationsTable[
                                                                    index]
                                                                .timeChain)[13]
                                                        [2]))),
                                          ],
                                        ),
                                        ListTile(
                                            title: Text('Ready: ' +
                                                readyCheck(
                                                    operationsTable[index]
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
            onItemFound: (Operations post, int index) {
              return ExpansionTile(
                key: Key('MainTile'),
                title: Text(
                  'PO: ${post.po}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('Invoice: ' +
                        stringExists(
                            operationsTable[index].invoiceID.toString())),
                  ),
                  ListTile(
                      title: Text('Tramit Date: ' +
                          commentExists(trimString(
                              operationsTable[index].tramitDate.toString(),
                              'T')))),
                  ListTile(
                      title: Text(
                          'Customs Name:  ${operationsTable[index].customsName}')),
                  ListTile(
                      title:
                          Text('Client: ${operationsTable[index].clientName}')),
                  ListTile(
                      title: Text(
                          'Transport Name: ${operationsTable[index].transportName}')),
                  ListTile(
                      title: Text('Arrival Date: ' +
                          commentExists(trimString(
                              operationsTable[index].arrivalDate.toString(),
                              'T')))),
                  ListTile(title: Text('Unit: ${operationsTable[index].unit}')),
                  ListTile(
                      title: Text('Process Date: ' +
                          commentExists(trimString(
                              operationsTable[index].processDate.toString(),
                              'T')))),
                  ExpansionTile(
                    title: Text('Time Chain'),
                    children: [
                      ListTile(
                          title: Text('Received',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[0][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[0][2]))),
                      ListTile(
                          title: Text('Documents to Client',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[1][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[1][2]))),
                      ListTile(
                          title: Text('Documents from Client',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[2][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[2][2]))),
                      ListTile(
                          title: Text('US Inspection',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[3][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[3][2]))),
                      ListTile(
                          title: Text('Agency',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[4][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[4][2]))),
                      ListTile(
                          title: Text('Transfer',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[5][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[5][2]))),
                      ListTile(
                          title: Text('PO Requested',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[6][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[6][2]))),
                      ListTile(
                          title: Text('PO Received',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[7][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[7][2]))),
                      ListTile(
                          title: Text('Transferred',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[8][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[8][2]))),
                      ListTile(
                          title: Text('Bodega Exit',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[9][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[9][2]))),
                      ListTile(
                          title: Text('Customs Entrance',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[10][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[10][2]))),
                      ListTile(
                          title: Text('Customs Exit',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[11][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[11][2]))),
                      ListTile(
                          title: Text('Point of Inspection Entrance',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[12][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[12][2]))),
                      ListTile(
                          title: Text('Point of Inspection Exit',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(
                          title: Text('Date: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[13][1]))),
                      ListTile(
                          title: Text('Hour: ' +
                              stringExists(timeChainBreak(
                                  operationsTable[index].timeChain)[13][2]))),
                    ],
                  ),
                  ListTile(
                      title: Text('Ready: ' +
                          readyCheck(operationsTable[index].ready))),
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
          icon: Icon(Icons.analytics),
          label: 'Quick View',
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

  List<Operations> operationsTable = [];
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
            key: Key('goBack'),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: _searchWidget(context),
      bottomNavigationBar: bottomMenu(context),
    );
  }
}
