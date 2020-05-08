import 'package:flutter/material.dart';

import './pages/loginPage.dart';
import './pages/registerPage.dart';
import './pages/mainPage.dart';
import './pages/incomingCallPage.dart';
import './pages/ongoingCallPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.routeName,
      theme: ThemeData(
        fontFamily: 'Solway',
        textTheme: TextTheme(
          headline5: TextStyle(color: Colors.blue),
          headline6: TextStyle(color: Colors.blue),
          subtitle1: TextStyle(color: Colors.blue),
          caption: TextStyle(color: Colors.blue),
          button: TextStyle(color:Colors.blue),
        ),
      ),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        MainPage.routeName: (context) => MainPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        IncomingCall.routeName: (context) => IncomingCall(),
        OngoingCall.routeName: (context) => OngoingCall(),
      },
    );
  }
}