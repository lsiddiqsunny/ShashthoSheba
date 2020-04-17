import 'package:flutter/material.dart';

import './homePage.dart';
import './loginPage.dart';
import './registerPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        RegisterPage.routeName: (context) => RegisterPage(),
      },
    );
  }
}
