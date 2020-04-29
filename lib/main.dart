import 'package:flutter/material.dart';

import './pages/loginPage.dart';
import './pages/registerPage.dart';
import './pages/mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.routeName,
      theme: ThemeData(
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 28, color: Colors.blue),
          title: TextStyle(fontSize: 24, color: Colors.blue),
          body1: TextStyle(fontSize: 16),
          body2: TextStyle(fontSize: 16),
          button: TextStyle(fontSize: 16, color:Colors.blue),
        ),
      ),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        MainPage.routeName: (context) => MainPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
      },
    );
  }
}
