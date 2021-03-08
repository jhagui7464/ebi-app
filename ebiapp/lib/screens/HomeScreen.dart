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
      title: Text("Welcome, ${widget.user.uname}"),
    ));
  }
}
