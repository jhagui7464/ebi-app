import 'package:ebiapp/screens/HomeScreen.dart';
import 'package:ebiapp/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          "Settings",
          key: Key('settings'),
        ),
      ),
      body: Center(
        child: Container(
            color: Colors.white,
            child: Card(
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
                },
              ),
            )),
      ),
    );
  }
}
