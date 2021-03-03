import 'package:flutter/material.dart';
import '../utils/ebiAPI.dart';
import '../utils/globals.dart';

class LoginScreen extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Loading Screen',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPrompt(title: 'Login Screen'),
    );
  }
}

class LoginPrompt extends StatefulWidget {
  LoginPrompt({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPromptState createState() => _LoginPromptState();
}

class _LoginPromptState extends State<LoginPrompt> {
  String user;
  String password;

  bool loginValid = true;
  bool showError = false;
  Future<UserData> futureUser;
  @override
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Center(
      //this contains the background for the login screen
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill)),

        //this will be the logo following the login boxes with the contact information
        //at the bottom
        child: Column(
          children: [
            Container(
                child: Padding(
              padding: EdgeInsets.fromLTRB(10, 70, 10, 0),
              child: Image.asset(
                'assets/images/ebi_02.png',
                height: 240,
                width: 200,
              ),
            )),

            //USER ID
            Container(
              width: 250,
              //margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: TextField(
                onChanged: (String value) async {
                  user = value;

                  setState(() {});
                },
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'User ID'),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),

            Divider(),

            //Password
            Container(
              width: 250,
              //margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: TextField(
                obscureText: true,
                onChanged: (String value) async {
                  password = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Password'),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Divider(),
            Container(
                width: 150,
                child: FlatButton(
                    child: Text("Login"),
                    onPressed: () {
                      futureUser = EBIapi().fetchUser(user);
                      //verify the user here via dbFuture<UserData> futureUser;
                      //if user is valid, we go to next screen.
                      setState(() {});
                      if (loginValid) {
                        print("test");
                      } else {}
                      //otherwise show error message
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))),
            Divider(),
            Container(),

            FutureBuilder<UserData>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  loginValid = userValidation(snapshot.data.password, password);
                } else if (snapshot.hasError) {
                  return Text("Username or Password are Invalid");
                }

                // By default, show a loading spinner.
                return Container(width: 0, height: 0);
                //return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
