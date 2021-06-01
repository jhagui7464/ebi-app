import 'package:flutter/cupertino.dart';
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

  Widget _loginWidget(BuildContext context) {
    precacheImage(AssetImage("assets/images/ebi_02.png"), context);
    ImageProvider logo = AssetImage("assets/images/ebi_02.png");
    Image logoImage = Image(
      image: logo,
      width: 250.0,
      height: 167.0,
    );
    precacheImage(AssetImage("assets/images/background.png"), context);
    ImageProvider background = AssetImage('assets/images/background.png');
    return new Center(
      //this contains the background for the login screen
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(image: background, fit: BoxFit.fill)),

        //this will be the logo following the login boxes with the contact information
        //at the bottom
        child: Column(
          children: [
            Container(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 80, 10, 40),
              child: logoImage,
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
              child: ElevatedButton(
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
                    futureUser = EBIapi().fetchUser(
                        userController.text, generateMd5(passController.text));
                  });
                },
                // color: Colors.white,
                // shape: RoundedRectangleBorder(
                //   borderRadius: new BorderRadius.circular(30.0),
                // ),
              ),
            ),
            Divider(),
            FutureBuilder<UserData>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  currentUser = snapshot.data;
                  print('${currentUser.uname}');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomeScreen(currentUser),
                        ));
                  });
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(child: CircularProgressIndicator());
                } else {
                  return Container(width: 0, height: 0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _loginWidget(context));
  }
}
