import 'package:flutter/material.dart';
import '../utils/ebiAPI.dart';
import '../utils/globals.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<UserData> futureUser;
  UserData currentUser;

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
                key: Key('login-screen'),
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
                key: Key('user-name'),
                controller: userController,
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
                key: Key('pass-word'),
                obscureText: true,
                controller: passController,
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
                child: RaisedButton(
                    key: Key('login-button'),
                    child: Text(
                      "Login",
                      key: Key('login-text'),
                    ),
                    onPressed: () {
                      //verify the user here via dbFuture<UserData> futureUser;
                      //if user is valid, we go to next screen.
                      //otherwise show error message
                      setState(() {
                        futureUser = EBIapi().fetchUser(userController.text,
                            generateMd5(passController.text));
                      });
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))),
            Divider(),
            FutureBuilder<UserData>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  currentUser = snapshot.data;
                  print('${currentUser.uname}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(currentUser),
                      ));
                } else if (snapshot.hasError) {
                  return Text(
                    "Username or Password are Invalid",
                    key: Key('notification'),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
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
