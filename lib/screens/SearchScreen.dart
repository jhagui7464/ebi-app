import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import '../utils/globals.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<ClientTable> tables;

  SearchScreen(this.tables);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<ClientTable>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(widget.tables.length, (int index) {
      return ClientTable();
    });
  }

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
            onSearch: search,
            onItemFound: (ClientTable post, int index) {
              return ExpansionTile(
                key: Key('MainTile'),
                title: Text(
                  'PO: ${post.po}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                    title: Text(
                        'Delivery Date: ' + trimString(post.deliverDate, 'T')),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            'Delivery Hour: ' + stringExists(post.deliverHour)),
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
            },
          ),
        ),
      ),
    );
  }
}
